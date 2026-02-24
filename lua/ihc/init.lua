require("ihc.options")

-- Activar LSPs
vim.lsp.enable({
  "clangd",
  "lua-language-server",
  "verible",
  "pyright",
})

require("ihc.lazy.lazy")



-- Autocompletado al conectar un cliente
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
  local buf = ev.buf

  local function map(lhs, rhs, desc)
    vim.keymap.set('n', lhs, rhs, {
      buffer = buf,
      desc = desc
    })
  end

    -- Autocompletado
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, ev.buf)
    end

    -- Keymaps
    -- LSP navigation
    map('K',  vim.lsp.buf.hover, "Hover documentation")
    map('gd', vim.lsp.buf.definition, "Go to definition")
    map('gr', vim.lsp.buf.references, "Go to references")
    map('gi', vim.lsp.buf.implementation, "Go to implementation")

    -- Actions
    map('<leader>rr', vim.lsp.buf.rename, "Rename symbol")
    map('<leader>ca', vim.lsp.buf.code_action, "Code action")

    -- Diagnostics
    map('gD', vim.diagnostic.open_float, "Show diagnostics under cursor")
    vim.keymap.set('n', '<leader>gD',
      require('telescope.builtin').diagnostics,
      { desc = "Diagnostics (Telescope)" })
    end,
})

