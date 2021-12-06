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

" The tim pope collection :)
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-commentary'

Plug 'airblade/vim-gitgutter'

Plug 'mbbill/undotree'

Plug 'ctrlpvim/ctrlp.vim'

Plug 'majutsushi/tagbar'

Plug 'mattn/emmet-vim'

Plug 'mileszs/ack.vim'

" Vimwiki magicks
Plug 'vimwiki/vimwiki'
Plug 'tools-life/taskwiki'
Plug 'powerman/vim-plugin-AnsiEsc'
Plug 'farseer90718/vim-taskwarrior'

Plug 'easymotion/vim-easymotion'

Plug 'mhinz/vim-startify'

" Autocompletion plugins
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'ervandew/supertab'
Plug 'Shougo/unite.vim'

Plug 'hashivim/vim-terraform'

Plug 'SirVer/ultisnips'
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
set relativenumber

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
nmap <leader>bb :CtrlPBuffer<CR>

" Tab management (same as buffers more or less)
nmap <leader>tn :tn<CR>
nmap <leader>tp :tp<CR>

" Foldlevel manipulation
nmap <leader>zz :set foldlevel=0<CR>
nmap <leader>za :set foldlevel=9999<CR>

" Emmet
nmap <leader>e <C-y>,

" Search
nmap <leader>ag :Ack

" File finding
let g:ctrlp_map = ''
nmap <leader>ff :CtrlP<CR>
nmap <leader>fF :CtrlPCurWD<CR>

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

" ack.vim {{{
if executable('ag')
	let g:ackprg = 'ag --vimgrep'
endif
" }}}

" Python stuff {{{
let g:pymode_python='python3'
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
