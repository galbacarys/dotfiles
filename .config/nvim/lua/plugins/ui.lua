vim.opt.mouse = ''
vim.opt.number = true

df_mode = false

function distraction_free_mode_toggle()
	require('lualine').hide({ unhide = df_mode })
	df_mode = not df_mode
	if df_mode then
		vim.cmd [[ Goyo ]]
		vim.cmd [[ Limelight ]]
	else
		vim.cmd [[ Goyo! ]]
		vim.cmd [[ Limelight! ]]
	end
end
	
vim.keymap.set('n', '<leader>df', distraction_free_mode_toggle)

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
	},
	-- distraction-free mode
	{
		'junegunn/goyo.vim'
	},
	{
		'junegunn/limelight.vim'
	}
}
