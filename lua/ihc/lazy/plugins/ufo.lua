return {
	'kevinhwang91/nvim-ufo',
	dependencies = {'kevinhwang91/promise-async'},

	config = function()
		local ufo = require('ufo')

		vim.o.foldcolumn = '0'
		vim.o.foldlevel = 99 -- Using ufo provider need a large value
		vim.o.foldlevelstart = 99
		vim.o.foldenable = true

		vim.keymap.set('n', 'zR', ufo.openAllFolds, {desc = "Open all folds", noremap = true})
		vim.keymap.set('n', 'zM', ufo.closeAllFolds, {desc = "Close all folds", noremap = true})
		vim.keymap.set('n', 'zK', function()
			local winid = ufo.peekFoldedLinesUnderCursor()
			if not winid then
				vim.lsp.buf.hover()
			end
			end, {desc = "Preview fold", noremap  = true})

		ufo.setup({
	 	provider_selector =	function(bufnr, filetype, buftype)
				return {'lsp', 'indent'}
			end
		})

	end
}
