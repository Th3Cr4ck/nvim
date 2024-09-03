return{
	'nvim-lualine/lualine.nvim',
	dependencies = { 'nvim-tree/nvim-web-devicons' },
	lazy = false,

	config = function()
		require('lualine').setup{
			sections = {
				lualine_y = {'buffers'},
				lualine_z = {'datetime'}
			},
			options = {
				globalstatus = true -- make global lualine showing
			},
		}
	end
}

