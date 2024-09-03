return{
 -- 'EdenEast/nightfox.nvim',
    -- "rebelot/kanagawa.nvim",
'uloco/bluloco.nvim',
dependencies = { 'rktjmp/lush.nvim' },
	lazy = false, -- make sure we load this during startup 
	priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      	-- load the colorscheme here
        -- vim.cmd([[colorscheme nightfox]])
        -- vim.cmd([[colorscheme dayfox]])
		-- vim.cmd("colorscheme kanagawa")
		require ("bluloco").setup({transparent = true})
		vim.cmd("colorscheme bluloco")
		transparent = true
    end,

}

