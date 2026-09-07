return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local telescope    = require("telescope")
    local actions      = require("telescope.actions")
    local finders      = require("telescope.finders")
    local pickers      = require("telescope.pickers")
    local conf         = require("telescope.config").values
    local action_state = require("telescope.actions.state")

    telescope.setup({
      defaults = {
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-j>"] = actions.move_selection_next,
            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
          }
        }
      }
    })

    telescope.load_extension("fzf")

    -- ── LSP Find All References ─────────────────────────────────────────
    local LSP_REQUESTS = {
      { method = "textDocument/definition",     label = "Def",  priority = 1 },
      { method = "textDocument/declaration",    label = "Decl", priority = 2 },
      { method = "textDocument/implementation", label = "Impl", priority = 3 },
      { method = "textDocument/references",     label = "Ref",  priority = 4 },
    }

    local function get_line_content(fname, lnum)
      local ok, lines = pcall(vim.fn.readfile, fname, "", lnum)
      if ok and lines[lnum] then return vim.trim(lines[lnum]) end
      return ""
    end

    local function open_results_picker(results, query)
      table.sort(results, function(a, b) return a.priority < b.priority end)

      pickers.new({}, {
        prompt_title    = "Results: " .. query,
        finder          = finders.new_table({
          results = results,
          entry_maker = function(entry)
            return {
              value    = entry,
              display  = entry.display,
              ordinal  = entry.display,
              filename = entry.filename,
              lnum     = entry.lnum,
              col      = entry.col,
            }
          end,
        }),
        sorter          = conf.generic_sorter({}),
        previewer       = conf.grep_previewer({}),
        attach_mappings = function(prompt_bufnr)
          actions.select_default:replace(function()
            local sel = action_state.get_selected_entry()
            actions.close(prompt_bufnr)
            if sel then
              vim.cmd("edit " .. sel.filename)
              vim.api.nvim_win_set_cursor(0, { sel.lnum, sel.col - 1 })
            end
          end)
          return true
        end,
      }):find()
    end

    local function do_lsp_search(query, original_buf)
      local clients = vim.lsp.get_clients({ bufnr = original_buf })
      local results = {}
      local seen    = {}

      -- Sin LSP: fallback grep puro
      if #clients == 0 then
        local lines = vim.fn.systemlist("rg --vimgrep --smart-case " .. vim.fn.shellescape(query))
        for _, raw in ipairs(lines) do
          local file, lnum, col, text = raw:match("^(.+):(%d+):(%d+):(.+)$")
          if file then
            table.insert(results, {
              priority = 4,
              filename = file,
              lnum     = tonumber(lnum),
              col      = tonumber(col),
              display  = string.format("[Ref] %s:%s  %s",
                vim.fn.fnamemodify(file, ":t"), lnum, vim.trim(text)),
            })
          end
        end
        open_results_picker(results, query)
        return
      end

      -- Mover el cursor temporalmente a una ocurrencia del símbolo
      -- para que los params de posición sean válidos
      local grep_lines = vim.fn.systemlist(
        "rg --vimgrep -m 1 --smart-case " .. vim.fn.shellescape(query)
      )
      if #grep_lines == 0 then
        vim.notify("No results for: " .. query, vim.log.levels.INFO)
        return
      end

      -- Tomar la primera ocurrencia como posición de referencia
      local first_file, first_lnum, first_col = grep_lines[1]:match("^(.+):(%d+):(%d+):")
      if not first_file then
        vim.notify("No results for: " .. query, vim.log.levels.INFO)
        return
      end

      -- Abrir el buffer en background y hacer las requests desde ahí
      local target_buf = vim.fn.bufadd(first_file)
      vim.fn.bufload(target_buf)

      local params = {
        textDocument = vim.lsp.util.make_text_document_params(target_buf),
        position     = {
          line      = tonumber(first_lnum) - 1,
          character = tonumber(first_col) - 1,
        },
      }

      local pending = #clients * #LSP_REQUESTS

      local function try_open()
        pending = pending - 1
        if pending == 0 then
          -- Agregar referencias grep que no estén ya en los resultados LSP
          local all_grep = vim.fn.systemlist(
            "rg --vimgrep --smart-case " .. vim.fn.shellescape(query)
          )
          for _, raw in ipairs(all_grep) do
            local file, lnum, col, text = raw:match("^(.+):(%d+):(%d+):(.+)$")
            if file then
              local key = file .. ":" .. lnum
              if not seen[key] then
                seen[key] = true
                table.insert(results, {
                  priority = 4,
                  filename = file,
                  lnum     = tonumber(lnum),
                  col      = tonumber(col),
                  display  = string.format("[Ref] %s:%s  %s",
                    vim.fn.fnamemodify(file, ":t"), lnum, vim.trim(text)),
                })
              end
            end
          end
          open_results_picker(results, query)
        end
      end

      for _, client in ipairs(clients) do
        for _, req in ipairs(LSP_REQUESTS) do
          local req_params = params
          if req.method == "textDocument/references" then
            req_params = vim.tbl_extend("force", params, {
              context = { includeDeclaration = false }
            })
          end

          client.request(req.method, req_params, function(err, result)
            if not err and result then
              local items = vim.islist(result) and result or { result }
              for _, item in ipairs(items) do
                local uri   = item.uri or item.targetUri
                local range = item.range or item.targetSelectionRange or item.targetRange
                if uri and range then
                  local key = uri .. ":" .. range.start.line
                  if not seen[key] then
                    seen[key]     = true
                    local fname   = vim.uri_to_fname(uri)
                    local lnum    = range.start.line + 1
                    local content = get_line_content(fname, lnum)
                    table.insert(results, {
                      priority = req.priority,
                      filename = fname,
                      lnum     = lnum,
                      col      = range.start.character + 1,
                      display  = string.format("[%s] %s:%d  %s",
                        req.label,
                        vim.fn.fnamemodify(fname, ":t"),
                        lnum, content),
                    })
                  end
                end
              end
            end
            try_open()
          end, target_buf)
        end
      end
    end

    local function find_all_references()
      local original_buf = vim.api.nvim_get_current_buf()

      -- Stage 1: picker solo para escribir la búsqueda
      pickers.new({}, {
        prompt_title    = "  Find All References",
        finder          = finders.new_table({ results = {} }),
        sorter          = conf.generic_sorter({}),
        attach_mappings = function(prompt_bufnr)
          actions.select_default:replace(function()
            local query = action_state.get_current_line()
            actions.close(prompt_bufnr)
            if query and query ~= "" then
              -- Stage 2: buscar y abrir resultados
              vim.schedule(function()
                do_lsp_search(query, original_buf)
              end)
            end
          end)
          return true
        end,
      }):find()
    end
    -- ────────────────────────────────────────────────────────────────────

    local keymap = vim.keymap
    keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
    keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })
    keymap.set("n", "<leader>fs", find_all_references, { desc = "Find All References (LSP)" })
    keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })
    keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "Find buffers" })
  end,
}
