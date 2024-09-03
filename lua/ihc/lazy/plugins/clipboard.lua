return {
	'EtiamNullam/deferred-clipboard.nvim',
	lazy = false,
	config = function()
		require('deferred-clipboard').setup {
			fallback = 'unnamedplus', -- or your preferred setting for clipboard
			force_init_unnamed = true
		}
	end
}
