vim.opt.mouse = ''
vim.opt.number = true

return {
	-- color scheme
	{
		'rebelot/kanagawa.nvim',
		init = function()
			vim.cmd [[ colorscheme kanagawa ]]
		end
	},
	-- basic status line: lualine
	{
		'nvim-lualine/lualine.nvim',
		dependencies = { 'nvim-tree/nvim-web-devicons' },
		opts = {
			icons_enabled = true,
			theme = 'base16',
			section_separators = '',
			component_seporators = '', -- No separators for me thanks
		}

	},
	-- git gutter
	{
		'lewis6991/gitsigns.nvim',
		init = function()
			require('gitsigns').setup {}
		end
	}
}
