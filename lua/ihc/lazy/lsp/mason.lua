return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
	},
	event = "BufReadPre",
	config = function()
		-- import mason 
		local mason = require("mason")

		-- import mason lspconfig
		local mason_lspconfig = require("mason-lspconfig")

		-- enable mason and configure icons
		mason.setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗"
				}
			}
		})

		mason_lspconfig.setup({
			ensure_installed = {
				"efm",
				"lua_ls",
				"clangd",
				"arduino_language_server",
				"svlangserver",
				"bashls",
				-- "cssls",
				-- "html"
				--"rust-analyzer"
			},
			automatic_installation = true,
		})


	end,
}
