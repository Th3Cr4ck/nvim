local capabilities = require("cmp_nvim_lsp").default_capabilities()

return {
	cmd = {'lua-language-server'},
	filetypes = { 'lua' },
	root_markers = {
		'.luarc.json',
		'.luarc.jsonc',
		'.luacheckrc',
		'.git',
	},
  capabilities = capabilities,
}
