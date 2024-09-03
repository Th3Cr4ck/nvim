local function my_on_attach(bufnr)
    local api = require('nvim-tree.api')

    local function opts(desc)
      return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end

	-- default mappings
	api.config.mappings.default_on_attach(bufnr)

	-- custom mappings
	vim.keymap.set('n', '<Leader><Leader>', api.node.open.edit, opts("Open"))
end


return{
	'nvim-tree/nvim-tree.lua',
	lazy = true,
	config = function()
		require("nvim-tree").setup {
			on_attach = my_on_attach,
		}

		-- custom mapping
		vim.keymap.set('n', '<Leader>tr', "<cmd>NvimTreeFocus<CR>", {nowait = true, silent = true})
		vim.keymap.set('n', '<Leader>ee', "<cmd>NvimTreeToggle<CR>", {nowait = true, silent=true})

		-- disable netrw for using nvim tree
		vim.g.loaded_netrw = 1
		vim.g.loaded_netrwPlugin = 1

	end,
}

