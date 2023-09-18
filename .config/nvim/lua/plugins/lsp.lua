-- LSP magicks

return {
	{ 'neovim/nvim-lspconfig' },
	{ 
		'williamboman/mason.nvim',
		config = function()
			require('mason').setup()
		end
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
		config = function()
			local caps = require("cmp_nvim_lsp").default_capabilities()

			-- get everything set up for our known language servers
			local lspconfig = require('lspconfig')

			local servers = { 'jdtls', 'gopls', 'pyright' }
			for _, lsp in ipairs(servers) do
				if lsp ~= 'jdtls' then -- Java has its own special handling, see below
					lspconfig[lsp].setup {
						capabilities = caps,
					}
				end
			end
		end,
		keys = {
			{ '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<cr>', desc = 'Code Actions' },
		}
	},
	{
		'mfussenegger/nvim-jdtls',
		config = function()
			vim.api.nvim_create_autocmd('FileType', {
				pattern = 'java',
				callback = function()
					-- Java specific bollocks
					local root_markers = { '.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle' }
					local root_dir = require('jdtls.setup').find_root(root_markers)

					local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
					local workspace_dir = vim.fn.stdpath "data" .. "/site/java/workspace-root/" .. project_name
					os.execute('mkdir -p ' .. workspace_dir)

					-- mason install path
					local installpath = require('mason-registry').get_package('jdtls'):get_install_path()

					local os
					if vim.fn.has 'macunix' then
						os = 'mac'
					elseif vim.fn.has 'win32' then
						os = 'win'
					else
						os = 'linux'
					end

					require('jdtls').start_or_attach({
						capabilities = caps,
						cmd = {
							"java",
							"-Declipse.application=org.eclipse.jdt.ls.core.id1",
							"-Dosgi.bundles.defaultStartLevel=4",
							"-Declipse.product=org.eclipse.jdt.ls.core.product",
							"-Dlog.protocol=true",
							"-Dlog.level=ALL",
							"-javaagent:" .. installpath .. "/lombok.jar",
							"-Xms1g",
							"--add-modules=ALL-SYSTEM",
							"--add-opens",
							"java.base/java.util=ALL-UNNAMED",
							"--add-opens",
							"java.base/java.lang=ALL-UNNAMED",
							"-jar",
							vim.fn.glob(installpath .. "/plugins/org.eclipse.equinox.launcher_*.jar"),
							"-configuration",
							installpath .. "/config_" .. os,
							"-data",
							workspace_dir,
						},
						root_dir = function()
							return root_dir
						end
				})
				end
			})
			return true
		end
	}
}
