vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.cursorline = true

vim.g.mapleader = ' '

-- make tab 2 spaces
vim.opt.expandtab = true -- usar espacios
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 6

vim.opt.signcolumn = "yes"

vim.opt.wrap = false

-- Habilitar la extensión tabline en Airline
vim.g.airline_extensions_tabline_enabled = 1

-- Keymaps binding
vim.keymap.set("n", "yaa", ":%y<CR>", { desc = "Copia todo el texto del buffer" })
vim.keymap.set("n", "vaa", "gg0vG$", { desc = "Selecciona todo el texto del buffer" })

vim.keymap.set("i", "jk", "<Esc>", { desc = "Sale del modo insertar" })
vim.keymap.set("i", "JK", "<Esc>", { desc = "Sale del modo insertar" })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Mueve el texto seleccionado hacia abajo" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Mueve el texto seleccionado hacia arriba" })

vim.keymap.set("i", ":w<CR>", "<Esc>:w<CR>", { desc = "Sale del modo insertar y guarda el archivo" })
vim.keymap.set("i", ":wq<CR>", "<Esc>:wq<CR>", { desc = "Sale del modo insertar, guarda el archivo y sale de neovim" })
vim.keymap.set("i", ":W<CR>", "<Esc>:w<CR>", { desc = "Sale del modo insertar y guarda el archivo" })
vim.keymap.set("i", ":Wq<CR>", "<Esc>:wq<CR>", { desc = "Sale del modo insertar, guarda el archivo y sale de neovim" })

vim.keymap.set("n", "<Leader>h", "<C-w>h", { desc = "Ir a la ventana izquierda" })
vim.keymap.set("n", "<Leader>j", "<C-w>j", { desc = "Ir a la ventana de arriba" })
vim.keymap.set("n", "<Leader>k", "<C-w>k", { desc = "Ir a la ventana de abajo" })
vim.keymap.set("n", "<Leader>l", "<C-w>l", { desc = "Ir a la ventana derecha" })

vim.keymap.set('n', '<Leader>bb', ':bn<CR>', { desc = "Ir al siguiente buffer" })

vim.keymap.set("n", "<leader>lf", function() -- LSP format
  vim.lsp.buf.format({ async = false })
end, { desc = "LSP Format buffer" })

-- Lua indent to 2 spaces
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "lua",
--   callback = function()
--     vim.bo.shiftwidth = 2
--     vim.bo.tabstop = 2
--     vim.bo.softtabstop = 2
--     vim.bo.expandtab = true
--   end,
-- })
--
-- -- Verilog indent to 2 spaces
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = { "verilog", "systemverilog" },
--   callback = function()
--     vim.opt_local.expandtab = true -- usar espacios
--     vim.opt_local.tabstop = 2      -- tamaño visual del tab
--     vim.opt_local.shiftwidth = 2   -- indentación automática
--     vim.opt_local.softtabstop = 2
--   end,
-- })
