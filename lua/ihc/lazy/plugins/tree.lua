-- lua/plugins/nvim-tree.lua
local function my_on_attach(bufnr)
    local api = require('nvim-tree.api')

    local function opts(desc)
        return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end

    -- default mappings
    api.config.mappings.default_on_attach(bufnr)

    -- custom mapping dentro del buffer del árbol
    vim.keymap.set('n', '<Leader><Leader>', api.node.open.edit, opts("Open"))
end

return {
    'nvim-tree/nvim-tree.lua',
    lazy = true,
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    -- Carga bajo demanda: se activa al ejecutar cualquiera de estos comandos
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    keys = {
        -- Keymaps globales para abrir/enfocar el árbol
        { "<Leader>ee", function() require("nvim-tree.api").tree.toggle() end, desc = "Toggle NvimTree" },
        { "<Leader>tr", function() require("nvim-tree.api").tree.focus() end, desc = "Focus NvimTree" },
    },
    config = function()
        -- Deshabilitar netrw antes de cargar nvim-tree
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1

        require("nvim-tree").setup({
            on_attach = my_on_attach,
            -- opciones recomendadas
            update_focused_file = {
                enable = true,
                update_cwd = true,
            },
            renderer = {
                highlight_git = true,
                icons = {
                    show = {
                        git = true,
                        folder = true,
                        file = true,
                        folder_arrow = true,
                    },
                },
            },
        })
    end,
}

