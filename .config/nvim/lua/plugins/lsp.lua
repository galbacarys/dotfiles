-- LSP magicks

return {
	{ 'neovim/nvim-lspconfig' },
	{
		'mason-org/mason.nvim',
		opts = {}
	},
	{
		'mason-org/mason-lspconfig.nvim',
		dependencies = { 'neovim/nvim-lspconfig', 'williamboman/mason.nvim' },
		opts = {}
	},
	{
		'hrsh7th/nvim-cmp',
		dependencies = { 
			'hrsh7th/cmp-buffer',
			'hrsh7th/cmp-path',
			'hrsh7th/cmp-cmdline',
			-- These are only required to set up _a_ snippet engine. This is a dumb requirement, cmp
			'L3MON4D3/LuaSnip',
			'saadparwaiz1/cmp_luasnip',
		},
		config = function()
			local cmp = require('cmp')

			cmp.setup({
				snippet = {
					expand = function(args)
						require('luasnip').lsp_expand(args.body)
					end,
				},
				sources = cmp.config.sources({
					{ name = 'nvim_lsp' },
					{ name = 'luasnip' },
				}),
				mapping = cmp.mapping.preset.insert({
					['<CR>'] = cmp.mapping.confirm({ select = true }),
					['<C-Space>'] = cmp.mapping.complete(),
				})
			}, { name = 'buffer' }) 

			cmp.setup.cmdline({ '/', '?' }, {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = 'buffer' }
				}
			})

			cmp.setup.cmdline(':', {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({ { name = 'path' } }, { { name = 'cmdline' } })
			})
		end
	},
	{
		'hrsh7th/cmp-nvim-lsp',
		dependencies = { 'neovim/nvim-lspconfig', 'hrsh7th/nvim-cmp' },
		lazy = false,
		keys = {
			{ '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<cr>', desc = 'Code Actions' },
			{ '<leader>h', '<cmd> lua vim.lsp.buf.hover()<cr>', desc = 'LSP Hover' }
		}
	},
	{
		'rachartier/tiny-inline-diagnostic.nvim',
		event = 'VeryLazy',
		priority = 1000,
		config = function()
			require('tiny-inline-diagnostic').setup()
			vim.diagnostic.config({ virtual_text = false })
		end
	}
}
