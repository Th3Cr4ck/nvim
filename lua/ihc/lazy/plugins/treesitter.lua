return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	lazy = false,
	priority = 50,
	config = function ()
		local configs = require("nvim-treesitter.configs")

		configs.setup({
			ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "c_sharp", "cpp", "verilog"},
			sync_install = false,
			highlight = { enable = true },
			indent = { enable = true },
		})
	end
}
