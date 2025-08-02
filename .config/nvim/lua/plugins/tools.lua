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
			require('telescope').load_extension('ui-select')
		end,

	},
	{
		-- we do the AI's now
		"greggh/claude-code.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		config = function()
			command = 'claude'
			if vim.fn.has 'macunix' then
				command = 'newt --app-type=java-project claude' -- work specific stuff
			end
			require("claude-code").setup({
				command = command,
				window = {
					position = "vertical"
				}
			})
		end
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
		opts = {
			focus = true,
			warn_no_results = false,
			open_no_results = true
		},
		cmd = 'Trouble',
		keys = {
			{ '<leader>qf', '<cmd>Trouble diagnostics toggle<cr>', desc = 'Workspace Diagnostics' },
			{ '<leader>gd', '<cmd>Trouble lsp toggle<cr>', desc = 'LSP omnifinder' },
			{ '<leader>gD', '<cmd>Trouble lsp_definitions toggle<cr>', desc = 'LSP definitions' },
		}
	},
}
