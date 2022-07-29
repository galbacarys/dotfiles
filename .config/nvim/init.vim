" vim: fdm=marker
" This ViMRC is neovim ONLY.

" Automatic setup of plug {{{
let s:plug_root=expand("~/.local/share/nvim/site/autoload/plug.vim")

let s:plug_installed=1
if !filereadable(s:plug_root)
	echo "Installing plug, please wait!"
	echo ""
	silent execute "!curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
	let s:plug_installed=0
endif
let &rtp = &rtp . ',' . s:plug_root

call plug#begin('~/.local/share/nvim/site/plugs')
"}}}

" Some basic preamble {{{
set nocompatible " be iMproved, required by vundle
set t_ut=        " fix some background color issues in tmux
" }}}

" Plugins {{{
Plug 'scrooloose/nerdtree'

Plug 'vim-airline/vim-airline'

Plug 'josuegaleas/jay'

"" The tim pope collection :)
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-commentary'

Plug 'airblade/vim-gitgutter'

Plug 'mbbill/undotree'

" Telescope and friends
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'

Plug 'majutsushi/tagbar'

Plug 'mattn/emmet-vim'

Plug 'easymotion/vim-easymotion'

Plug 'mhinz/vim-startify'

Plug 'ap/vim-css-color'

" Autocompletion plugins
Plug 'neovim/nvim-lspconfig'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'


" Language specific
Plug 'pangloss/vim-javascript'
Plug 'leafgarland/typescript-vim'
Plug 'google/vim-jsonnet'
Plug 'prettier/vim-prettier'

Plug 'hashivim/vim-terraform'

" Mostly for clojure, but generally useful for highly nested stuff
Plug 'jiangmiao/auto-pairs'
Plug 'kien/rainbow_parentheses.vim'
Plug 'tpope/vim-sexp-mappings-for-regular-people'
Plug 'guns/vim-sexp'
Plug 'tpope/vim-repeat'
"}}}

" More preamble {{{
call plug#end()

if !s:plug_installed
	echo "Installing plugins..."
	echo ""
	execute "PlugInstall"
endif

filetype plugin indent on " public static void main(String... args)
" }}}

" theme {{{
syntax on

set t_Co=256
colorscheme jay
set background=dark

set colorcolumn=80,120
set cursorline
" }}}

" Custom functions {{{

command! -range -nargs=0 -bar JsonTool <line1>,<line2>!python -m json.tool

" }}}

" runtime options {{{
" Backup files to tmp. Good enough in most circumstances, and backups are too
" annoying to deal with otherwise
set backupdir=/tmp//
set directory=/tmp//

" Now, undo's are a different story entirely
set undodir=$HOME/.vimundo
silent call system('mkdir -p ' . &undodir)
set undolevels=2048
set undoreload=16384
set undofile

" Position save/reload
au BufReadPost * if("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
" }}}

" Editing options {{{
" tabs {{{
set tabstop=2
set softtabstop=2
set shiftwidth=2
set noexpandtab
" }}} /tabs

" modelines {{{
set modeline
set modelines=5
"

" navigation {{{
set number relativenumber

" visual navigation
nnore j gj
nnore k gk
" better consistency for keybinds
nnore Y y$

" esc <-> jk
inore jk <esc>

" use space as leader
let mapleader=" "

" These probably belong better down with their individual plugins, but it's
" easier to manage the keybinds if they're all relatively together
" jools
nmap <leader>ft :NERDTreeToggle<CR>
nmap <leader>ut :UndotreeToggle<CR>
nmap <leader>tt :TagbarToggle<CR>

" Windows
nmap <leader>w <C-w>

" Buffer management
nmap <leader>bn :bn<CR>
nmap <leader>bp :bp<CR>
nmap <leader>bd :bd<CR>

" Tab management (same as buffers more or less)
nmap <leader>tn :tabnext<CR>
nmap <leader>tp :tabprevious<CR>

" Foldlevel manipulation
nmap <leader>zz :set foldlevel=0<CR>
nmap <leader>za :set foldlevel=9999<CR>

" Telescope
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>ag <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>bb <cmd>lua require('telescope.builtin').buffers()<cr>

" Scrolloff: prevent the cursor from moving more than 5 lines close to screen
" boundaries
set scrolloff=5

" }}} /navigation

" splits {{{
set splitbelow splitright
" }}}

" Search options {{{
set hlsearch incsearch
set smartcase
" }}}

" }}} /editing options

" Plugin customization {{{
" airline {{{
set laststatus=2 " arcane magicks?
let g:airline#extensions#tabline#nabled = 1
let g:airline#xtensions#tabline#left_sep = ''
let g:airline#xtensions#tabline#left_alt_sep = ''
let g:airline#xtensions#tabline#right_sep = ''
let g:airline_left_sep=''
let g:airline_right_sep=''
let g:airline_detect_modified=1
let g:airline_detect_paste=1
" }}} /airline

" Python stuff {{{
let g:pymode_python='python3'
" }}}

" General LSP Config {{{
"set completeopt=menu,menuone,noselect

lua << EOF
  -- Setup nvim-cmp.
  local cmp = require'cmp'

  cmp.setup({
		window = {
			--completion = cmp.config.window.bordered(),
			--documentation = cmp.config.window.bordered(),
		},
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
      ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
			['<C-Space>'] = cmp.mapping(cmp.mapping.complete({
				config = {
					sources = {
						name = 'nvim_lsp'
						}
					}
			}), { 'i', 'c' }),
      ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
      ['<C-e>'] = cmp.mapping({
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      }),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
    }, {
      { name = 'buffer' },
    })
  })

  -- Set configuration for specific filetype.
  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline('/', {
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })


local opts = { noremap=true, silent=true }
local on_attach = function(client, bufnr)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>gd',  "<cmd>lua require('telescope.builtin').lsp_definitions()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>gr',  "<cmd>lua require('telescope.builtin').lsp_references()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>hh',  "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>gss', "<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>gsa', "<cmd>lua require('telescope.builtin').lsp_workspace_symbols()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ge',  "<cmd>lua require('telescope.builtin').diagnostics()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>gca', "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rr', "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ge', "<cmd>lua require('telescope.builtin').diagnostics()<CR>", opts)
end

local servers = { 'tsserver', 'clojure_lsp', 'pyright', 'jsonnet_ls', 'gopls' }
-- Setup lspconfig.
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
for _, lsp in pairs(servers) do
	require('lspconfig')[lsp].setup {
			on_attach = on_attach,
			flags = {
				debounce_text_changes = 150,
			},
			capabilities = capabilities,
		}
end
EOF
" }}}

" {{{  Prettier
let g:prettier#autoformat = 1
let g:prettier#autoformat_require_pragma = 0
" to avoid dumb whitespace issues
let g:gitgutter_diff_args = '-w'
" }}}

" startify
" {{{
let g:startify_change_to_dir = 0
let g:startify_change_to_vcs_root = 1
" }}}
" }}} /plugins

" Per-language augroups {{{
au BufNewFile,BufRead *.py
			\ setlocal tabstop=4 softtabstop=4 shiftwidth=4 textwidth=80
			\ expandtab autoindent fileformat=unix

au BufNewFile,BufRead *.yml,*.yaml
			\ setlocal tabstop=2 softtabstop=2 shiftwidth=2 textwidth=120
			\ fdm=indent

au BufNewFile,BufRead *.wiki
			\ set tw=80 wrap linebreak nolist

" fix a syntax highlighting issue in ruby
augroup ft_rb
	au!
	au FileType ruby setlocal re=1 foldmethod=manual
augroup END
" }}} /augroups
