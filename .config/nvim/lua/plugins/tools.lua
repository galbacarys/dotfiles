-- Tools to make working in NViM more productive

return {
	-- Magic file parsing goodies
	{
		'nvim-treesitter/nvim-treesitter',
		build = ':TSUpdate',
		config = function()
			local configs = require("nvim-treesitter.configs")

			configs.setup({
				ensure_installed = { "lua", "vim", "vimdoc", "query", "java", "javascript", "html", "typescript", "css"},
				sync_install = false,
				highlight = { enable = true },
				indent = { enable = true },
			})
		end
	},
	-- Telescope is a universal fuzzy finder
	{
		'nvim-telescope/telescope.nvim', tag = '0.1.2',
		dependencies = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope-ui-select.nvim' },
		keys = {
			{ '<leader>ff', '<cmd>Telescope find_files<cr>', desc = 'Find Files'},
			{ '<leader>ag', '<cmd>Telescope live_grep<cr>', desc = 'Live Grep'},
			{ '<leader>bb', '<cmd>Telescope buffers<cr>', desc = 'Find Buffers'},
			{ '<leader>ss', '<cmd>Telescope lsp_workspace_symbols', desc = 'All symbols' },
		},
		config = function()
			require('telescope').setup {
				extensions = {
					['ui-select'] = {
						require('telescope.themes').get_dropdown {}
					}
				}
			}
			print("we're here")
			require('telescope').load_extension('ui-select')
		end,

	},
	-- Treeeeees, they are us
	{
		'nvim-tree/nvim-tree.lua',
		opts = {
			view = {
				width = 30,
			},
		},
		keys = {
			{ '<leader>ft', '<cmd>NvimTreeToggle<cr>', desc = 'Toggle file tree' },
		},
	},
	{
		'folke/trouble.nvim',
		dependencies = { 'nvim-tree/nvim-web-devicons' },
		keys = {
			{ '<leader>qf', '<cmd>TroubleToggle workspace_diagnostics<cr>', desc = 'Workspace Diagnostics' },
			{ '<leader>gd', '<cmd>TroubleToggle lsp_references<cr>', desc = 'LSP references' },
			{ '<leader>gD', '<cmd>TroubleToggle lsp_definitions<cr>', desc = 'LSP definitions' },
		}
	},
}
