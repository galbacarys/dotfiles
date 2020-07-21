" vim: fdm=marker

" READ THIS FIRST {{{
" There are a couple of things you'll need to do in order to make effective
" use of this configuration:
"
" 1) Install Vundle. This is simple: just run:
"	mkdir -p ~/.vim/bundle
"	git clone https://github.com/VundleVim/Vundle.vim ~/.vim/bundle
"	Note: This might work automagically now. NO GUARANTEES THOUGH.
" 2) Open Vim and run :PluginInstall to install all the plugins needed.
"	Note: This might work automagically now. NO GUARANTEES THOUGH.
" 3) (optional but highly recommended) Install ZShell.
"	brew install zsh
" 4) Install ag. Install ctags. Both are insanely useful, you won't regret it.
"
" Read through the entire file before proceeding, it's important to know what
" everything does, at least in general.
"
" Use `zc` and `zo` to close and open the folds in this file, things are
" arranged hierarchically and should be very easy to follow. If something is
" not well understood, it is a BUG. Please file a bug report on github.
"
" Thanks, and have fun!
" }}}

" AUTO-SETUP MAGICS {{{
" We'll detect which vim derivative we're using (vim vs. nvim)
if has('nvim')
	" and set the path to plug
	let s:plug_root=expand("~/.local/share/nvim/site/autoload/plug.vim")
else
	let s:plug_root=expand("~/.vim/autoload/plug.vim")
endif

" Then we can set up Plug
let s:plug_installed=1
if !filereadable(s:plug_root)
	echo "Installing Plug, please wait!"
	echo ""
	if has('nvim')
		silent execute "!curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
	else
		silent execute "!curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
	endif
	let s:plug_installed=0
endif
let &rtp = &rtp . ',' . s:plug_root

if has('nvim')
	call plug#begin('~/.local/share/nvim/site/plugs')
else
	call plug#begin('~/.vim/plugs')
endif
" }}}

" PREAMBLE {{{
set nocompatible              " be iMproved, required by Plug
filetype off                  " required by Vundle
set shell=/bin/zsh            " Replace with your favorite BASH-COMPATIBLE sh
set t_ut=                     " Fix background color issues in Tmux
" }}}

" PLUGINZ {{{
" Provides a neat project drawer, accessible through :NERDTreeToggle or <spc>ft
Plug 'scrooloose/nerdtree'
" Makes NERDTree a little easier to use
Plug 'jistr/vim-nerdtree-tabs'

" Provides that super-neat modeline at the bottom and top of the screen
Plug 'vim-airline/vim-airline'

" A soothing colorscheme for angry people
Plug 'josuegaleas/jay'

" The Tim Pope collection: provides lots of fancy features that Vim should
" just include at this point. Tim Pope is basically Bram Moolenaar 2.0.
" vim-fugitive: provides git integration through e.g. :Gstatus and :Gcommit
" Notes:
"	in Gstatus use the `-' key to stage/unstage a file.
Plug 'tpope/vim-fugitive'
" vim-surround: too complicated to explain fully, but here's the gist: it
" allows you to manipulate the surroundings of a text object. For example,
" <word> => [word] by using the commands `cs<[' when cursor anywhere on word
Plug 'tpope/vim-surround'
" Some sensible defaults that *definitely* should be part of Vim proper.
Plug 'tpope/vim-sensible'
" Short version: gcc comments/uncomments lines. gc takes a motion/count.
Plug 'tpope/vim-commentary'

" GitGutter gives you indicators on the left fringe ("gutter") of your
" window telling you which lines have been changed.
Plug 'airblade/vim-gitgutter'

" Turns out vim saves an awesome tree of your undo history. This plugin
" lets you visualize it.
Plug 'mbbill/undotree'

" Tagbar; useful for wiki navigation
Plug 'majutsushi/tagbar'

" CtrlP is a fuzzy finder. Type to narrow down what you want to find and hit
" enter when you find it.
Plug 'ctrlpvim/ctrlp.vim'

" Autocomplete parentheses and whatnot
Plug 'jiangmiao/auto-pairs'

" Emmet: make HTTP not fucking unbearable to write in Vim
Plug 'mattn/emmet-vim'

" Search plugin. Use with ack or ag to supercharge code search. (Note:
" requires ack or ag)
Plug 'mileszs/ack.vim'

"" Writing plugins
" A plugin for distraction-free writing.
Plug 'junegunn/goyo.vim'
" A plugin for wiki-ing
Plug 'vimwiki/vimwiki'
" A plugin for drawing fun boxen
Plug 'gyim/vim-boxdraw'

" easymotion. type spc-spc-w and see what happens.
Plug 'easymotion/vim-easymotion'

" Theeeeemes
Plug 'flazz/vim-colorschemes'

" A neat startpage
Plug 'mhinz/vim-startify'

" Java autocompletion. Will probably add more autocompletion features later,
" but I mostly code in java right now so whatever.
Plug 'artur-shaik/vim-javacomplete2'

" Gradle support (i.e. for Java)
Plug 'tfnico/vim-gradle'

" nice autocompletion extras
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'ervandew/supertab'
Plug 'Shougo/unite.vim'
Plug 'dense-analysis/ale'
"Snippets!
Plug 'SirVer/ultisnips'
" }}}

" MORE PREAMBLE {{{
call plug#end()

if !s:plug_installed
	echo "Installing plugins..."
	echo ""
	execute "PlugInstall"
endif

filetype plugin indent on " required for magic to happen
" }}}

" COLOR SCHEME {{{
" Yeah, no one actually codes without syntax highlighting, right?
syntax on

" Syntax highlighting: enable 256 colors and pick a theme
set t_Co=256 " because what the fuck terminal doesn't have 256 colors these
" days? It's not like I'm using a VT-100 or something
" This is where the actual theme is picked. I change this frequently.
colorscheme jay
set background=dark
" }}}

" EDITOR OPTIONS {{{
" Tab stuff {{{
" Because 2-space tabs are god
set tabstop=2
set softtabstop=2
set shiftwidth=2
" And use real tabs, not that namby-pamby expandtab bullshit
set noexpandtab
" }}}

" Modeline customization {{{
set laststatus=2 " What the fuck does this even mean?
let g:airline#extensions#tabline#enabled = 1
" Disable fancy separators-looks better in terminal
let g:airline#extensions#tabline#left_sep = ''
let g:airline#extensions#tabline#left_alt_sep = ''
let g:airline#extensions#tabline#right_sep = ''
let g:airline_left_sep=''
let g:airline_right_sep=''
" Make Airline do some neat detection stuff
let g:airline_detect_modified=1
let g:airline_detect_paste=1
set relativenumber
" }}}

" Splits {{{
" the only truly proper way to split things
set splitbelow
set splitright
" }}}

" Editing-related remaps {{{
" Note that these are mostly QoL stuff and cause vim builtins to behave
" properly. An explanation of each map should follow.

" Enable visual line navigation
nnoremap j gj
nnoremap k gk

" Make `Y' behave like its cousins, `D' and `R'
nnoremap Y y$

" Make jk act like <ESC> when in insert mode-easier than reaching up for the
" escape key and the only way to roll on these new hard mode macbooks
inoremap jk <esc>

if has('nvim')
  tnoremap <Esc> <C-\><C-n>
end
" }}}

" Disabling annoying features {{{
" I think everyone in the vim community hates how vim handles its backup
" files. So, an easy solution to avoid dealing with them is to dump them in
" /tmp, and that's what we're going to do.
set backupdir=/tmp//
set directory=/tmp//

" fix the stupid scrollbars in macvim
set guioptions=
" }}}

" Enabling neat features {{{
" ColorColumn is one of my favorite little features-light up a given column so
" that we know how long our lines are!
set colorcolumn=80,120
" Cursorline-see where your cursor is
set cursorline
" I really like line numbers. Sue me.
set nu
" Search options: highlight when we search things and search incrementally.
set hlsearch
set incsearch
set smartcase

" Scrolloff: prevent the cursor from moving more than 5 lines close to the
" screen boundaries
" Play around with it on a long file and you'll see what I mean
set scrolloff=5

" Persistent Undo. This is insanely important even though I ignored it for years...
set undodir=$HOME/.vim/vim.undo
" let's go ahead and create the undo directory if necessary
silent call system('mkdir -p ' . &undodir)
set undolevels=2048 " we could probably support much more than this, but 2048 undos oughta be enough for anyone
set undoreload=16384
set undofile
" }}}
" }}}

" MAGICAL AUTOMATION {{{
" Enabling modelines {{{
" Modelines are the neat little comments you can put in your files to make
" them override your vim's default settings. See the top of this file for
" examples, but basically know that Vim needs to see "vim: <stuff>" in the
" header of your file (the first 5 lines or so) for the settings to work.
set modeline
set modelines=5
" }}}

" autocmd groups {{{
" autocmd's (autocommands) are really neat. They allow for special commands to
" be run when files of certain types are opened. For example, if we're going
" to be opening a golang file, set the indentation differently because gofmt
" hates hard tabs (and puppies, probably).

" One other thing; we're probably going to keep these language specific for
" things like Groovy, Python, JS, etc. rather than doing a set of global
" settings because I might have very different opinions in one langugae versus
" another.

" Python augroups to force basic pep8 formatting (more or less :-P)
au BufNewFile,BufRead *.py
			\ setlocal tabstop=4 softtabstop=4 shiftwidth=4 textwidth=80
			\ expandtab autoindent fileformat=unix

" Fix the horrible markdown defaults
au BufNewFile,BufRead *.md
			\ setlocal textwidth=80 nospell

" Set text width in Javascript
" I like indent foldmethod in Javascript since callback hell is still a thing
" in <CURRENTYEAR>. Also, 2 space indents!
au BufNewFile,BufRead *.js,*.vue
			\ setlocal textwidth=80 fdm=indent tabstop=2 softtabstop=2 
			\ expandtab shiftwidth=2

" YAML stuff-2 sapce indent looks so, so, so much better in yaml than 4. Also
" set foldmethod to indent
au BufNewFile,BufRead *.yml,*.yaml
			\ setlocal tabstop=2 softtabstop=2 shiftwidth=2 fdm=indent

" Google code format for Java requires 2-width tab indents. Ugh.
" Might as well apply for java, kotlin, groovy, and gradle scripts
au BufNewFile,BufRead *.java,*.kt,*.groovy,*.gradle
      \ setlocal tabstop=2 softtabstop=2 shiftwidth=2 textwidth=120
      \ expandtab autoindent fileformat=unix

" Fix Makefiles since you have to not expand tabs...
au FileType make
      \ setlocal noexpandtab softtabstop=0 shiftwidth=8

" Some golang specific options and autocmd
let g:go_highlight_build_constraints = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_highlight_structs = 1
let g:go_highlight_types = 1
let g:go_auto_sameids = 1
let g:go_auto_type_info = 1
let g:go_fmt_command = "goimports"
let g:go_addtags_transform = "snakecase"

" ale-specific stuff
let g:ale_sign_error = '!!'
let g:ale_sign_warning = '!'
let g:airline#extensions#ale#enabled = 1

augroup ft_go
  au!
  au FileType go nnore <buffer> K :ALEHover<CR>
augroup END


" Other stuff

if has('nvim')
  " disable line numbers in terminal
  au TermOpen *
        \ set nonumber
end

" Add auto save/reload pos in case your Vim doesn't already have support enabled
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" Fix word wrap in vimwiki 
au BufNewFile,BufRead *.wiki
			\ set tw=80 wrap linebreak nolist

" Fix Vim's AWFUL syntax highlighting performance for ruby files
augroup ft_rb
    au!
    au FileType ruby setlocal re=1 foldmethod=manual
augroup END

au BufNewFile,BufRead Vagrantfile
			\ setlocal re=1

" some basic indentation rules for everything else. I prefer four spaces, but
" 2 is what we  use at work.
au BufNewFile,BufRead *
	\ setlocal tabstop=2 softtabstop=2 shiftwidth=2 textwidth=80
	\ expandtab autoindent
" }}}

" Leader bindings {{{
" The leader key is a special key we define that can then be used to make lots
" of fun custom keybindings that are (pretty much) guaranteed to never collide
" with anything in any plugins. We'll map it to SPC.
let mapleader=" "
" Mappings based on leader. I like keeping these as mnemonic as possible, for
" example: ft for file tree, ut for undotree, etc.
nmap <leader>ft :NERDTreeToggle<CR>
nmap <leader>ut :UndotreeToggle<CR>
nmap <leader>tt :TagbarToggle<CR>
" Ctrl-w is an awkward keybinding in my humble opinion. Replace it with ldr-w
nmap <leader>w <C-w>
" Buffer nav-I learned these keybindings in my spacemacs days and I'm too lazy
" to change them now
nmap <leader>bn :bn<CR>
nmap <leader>bp :bp<CR>
nmap <leader>bd :bd<CR>
" Also add leader-based bindings for fuzzy buffer finding. (also a spacemacs
" holdover)
nmap <leader>bb :CtrlPBuffer<CR>

" Paste mode (toggle with spc-p-m)
nmap <leader>pm :set paste!<CR>

" foldlevel manipulation
nmap <leader>zz :set foldlevel=0<CR>
nmap <leader>za :set foldlevel=9999<CR>

" Similar bindings to above for tabs
nmap <leader>tp :tabp<CR>
nmap <leader>tn :tabn<CR>

" Search binding: <spc>ag (isn't that cute)
nmap <leader>ag :Ack 

" Map <spc>e to the emmet functionality
nmap <leader>e <C-y>,

" Remapping ctrlp to spc-f-f since ctrl-p has other meanings I like better
" First completely unmap regular old ctrlp
let g:ctrlp_map = ''
" always ensures you're finding files from your current working directory
nmap <leader>ff :CtrlPCurWD<CR>
" But since the localdir version is sometimes useful...
nmap <leader>fF :CtrlP<CR>

" Adding a mapping for my custom :Insertdate function
nmap <leader>id :Insertdate<CR>I<BS> <ESC>$0x$

" Distraction free writing.
nmap <leader>df :Goyo<CR>
" and to close it
" Note the colorscheme hack. It fixes the coloring issues, but not elegantly.
" May try to make that better later
nmap <leader>dc :Goyo!<CR>:colorscheme jay<CR>

" codequery
nmap <leader>cm :CodeQueryMenu Unite<CR>
nmap <leader>cc :CodeQuery<CR>

" Custom functions {{{
" Some stuff I've whipped up or stolen from around teh internetz to make my
" life a little easier
command! -range -nargs=0 -bar JsonTool <line1>,<line2>!python -m json.tool
" Fixing yo typos
command! Q :q
command! Wq :wq
command! WQ :wq

" Box mode!
command! Boxon :set virtualedit+=all
command! Boxoff :set virtualedit-=all

" Nice light mode for if you're working outside or something
function! Light()
	set bg=light
	colorscheme morning
endfunction
command! Light :call Light()

" Dark mode to switch back
function! Dark()
	set bg=dark
	colorscheme jay
endfunction
command! Dark :call Dark()

" For inserting dates into files. useful for notes especially
command! Insertdate :r !date

" }}}
" }}}

" PLUGIN CUSTOMIZATION {{{
" Sometimes plugins don't work correctly. These are per-plugin customizations
" that (disclaimer) work on MY MACHINE AND MY MACHINE ONLY.
"
" Basically, here be dragons.

" ack.vim {{{
" Use ag if you have it. It's way faster than ack, you should get it.
if executable('ag')
	let g:ackprg = 'ag --vimgrep'
endif
" }}}

" vim-easytags {{{
" Attempts to improve performance
let g:easytags_syntax_keyword = 'always'
let g:easytags_async = 1
" }}}

" python-mode {{{
" Fix to use Python 3 by default. Usually a good thing to do.
let g:pymode_python='python3'
" }}}

" vimwiki {{{
let g:vimwiki_list = [{'path': '~/wiki'}, {'path': './wiki'}]
" }}}

" CTAGS stuff {{{
set tags=$HOME/tags
" }}}

" Java Bollocks {{{
autocmd FileType java setlocal omnifunc=javacomplete#Complete
let g:deoplete#enable_at_startup = 1
" }}}
" Go ALE stuff
let g:ale_linters = {
      \  'go': ['gopls']
      \ }
let g:ale_completion_enabled = 1

" ctrlp {{{
" this is dangerous on small/low-memory/weak machines, but I deal with 20,000 file projects.
" Deal with it I guess -\_(:/)_/-
let g:ctrlp_max_files=0
" }}}
" tagbar {{{
let g:tagbar_type_vimwiki = {
          \   'ctagstype':'vimwiki'
          \ , 'kinds':['h:header']
          \ , 'sro':'&&&'
          \ , 'kind2scope':{'h':'header'}
          \ , 'sort':0
          \ , 'ctagsbin':'~/src/dotfiles/bin/vwtags.py'
          \ , 'ctagsargs': 'default'
          \ }
" }}}
" ESOTERIC NONSENSE {{{
" Most of the stuff below is stuff I got from random places on the internet. It
" will likely change very frequently since it's mostly just silliness.

" Some window resizey magic
set winheight=30
set winwidth=30
silent! set winminheight=5
set winminwidth=20
" In normal mode, resize windows with leader-+ and leader-=
nnoremap <silent> <leader>= :exe "resize " . (winheight(0) * 3/2)<CR>
nnoremap <silent> <leader>- :exe "resize " . (winheight(0) * 2/3)<CR>
" In normal mode, resize windows vertically with _ and + (shifted versions of above shortcuts)
nnoremap <silent> <leader>+ :exe "vertical resize " . (winwidth(0) * 3/2)<CR>
nnoremap <silent> <leader>_ :exe "vertical resize " . (winwidth(0) * 2/3)<CR>

" some autocomplete customizations
set completeopt=longest,menuone
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "<C-g>u\<CR>"
" }}}
