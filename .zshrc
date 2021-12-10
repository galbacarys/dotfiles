# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="af-magic"

# Uncomment one of the following lines to change the auto-update behavior
zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Which plugins would you like to load?
plugins=(git vi-mode zsh-syntax-highlighting zsh-autosuggestions aws command-not-found virtualenv)

source $ZSH/oh-my-zsh.sh

# user config
if [ -f "~/.zshrc.local" ]; then
	source ~/.zshrc.local
fi

# Utility functions {{{
command_exists() {
	test -x "$(command -v $1)" > /dev/null 2>&1
}
# }}}

# Setting up some environmental stuff {{{
# Vim is love, vim is life
export EDITOR=`which nvim`

# fix tmux starting incorrectly possibly
if command_exists tmux; then
	alias tmux='tmux -2'
fi

# nvim if available
if command_exists nvim; then
	alias vim='nvim'
fi


# Go {{{
# Only configure if go exists in path
if command_exists go; then
	# My standard gopath location.
	export GOPATH=$HOME/go
	# Set up the gopath if it doesn't already exist.
	[ -d $GOPATH ] || mkdir -p $GOPATH
	# add the binaries folder of the gopath to PATH
	export PATH=$GOPATH/bin:$PATH
fi
# }}}

# Ruby (rbenv) {{{
if command_exists rbenv; then
	eval "$(rbenv init -)"
fi
# }}}
# }}}

# Extra path manipulation {{{
# Add /usr/local/bin to the path
#export PATH=/usr/local/bin:$PATH
# Add $HOME/bin to the path
export PATH=$HOME/bin:$PATH

# add dotfiles bin to the path
export PATH=$HOME/src/dotfiles/bin:$PATH
# }}}

# Source a local .zshrc if available, for machine-specific stuff {{{
if [ -f $HOME/.zshrc.local ]; then
	source $HOME/.zshrc.local
fi
# }}}

# Some extra custom functions {{{
alias servedir='python2 -mSimpleHTTPServer 8080'
alias c='clear'

## Set up vimwiki usage
alias vw="cd ~/wiki/ && vim --cmd 'let g:startify_disable_at_vimenter = 1' +VimwikiIndex && updatewiki"
alias diary="cd ~/wiki/ && vim --cmd 'let g:startify_disable_at_vimenter = 1' +VimwikiMakeDiaryNote && updatewiki"
alias updatewiki="vim +VimwikiDiaryIndex +VimwikiDiaryGenerateLinks +wall +VimwikiRebuildTags +VimwikiAll2HTML +qall"

if command_exists fzf; then
  # find-in-file
  alias fif="ag --nobreak --noheading . | fzf"
  # vim fuzzy-find
  vfzf() {
    vim "$(fzf)"
  }
  # find-in-file, then edit file in vim
  vfif() {
    found=$(fif)
    if [ $? -eq 0 ]; then # we found something!
      filename=$(echo $found | cut -f1 -d':')
      line=$(echo $found | cut -f2 -d':')
      vim +$line "$filename"
    fi
  }
fi

# Function for enabling small prompt (i.e. left prompt is just >>)
alias smallprompt='export PS1=">> "'
# }}}

# ssh-agent shenanigans {{{
#
# note that this works (sort of) on either macos or linux, but on macos the OS
# provides ssh-agent by default. This is cool, but also means that the first
# half of this code (checking if ssh-agent is running) is useless. It won't 
# break anything though.
# Ensure agent is running
ssh-add -l &>/dev/null
if [ "$?" = 2 ]; then
    # Could not open a connection to your authentication agent.

    # Load stored agent connection info.
    test -r ~/.ssh-agent && \
        eval "$(<~/.ssh-agent)" >/dev/null

    ssh-add -l &>/dev/null
    if [ "$?" = 2 ]; then
        # Start agent and store agent connection info.
        (umask 066; ssh-agent > ~/.ssh-agent)
        eval "$(<~/.ssh-agent)" >/dev/null
    fi
fi
# }}}

