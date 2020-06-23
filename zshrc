# vim: fdm=marker

# README FIRST {{{
# This zshrc depends on oh-my-zsh being installed and configured. Google it.
#
# Also, you should have fzf installed for fuzzy-finding goodness.
#
# Finally, make sure you add any edits to this to ~/.zshrc.local rather than
# this file to keep getting updates.
# }}}

# Oh-My-ZSH configuration {{{
# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh
# omzsh theme
ZSH_THEME="patched-ys"

# The most basic set of plugins possible. I don't need a lot :)
plugins=(git docker virtualenv zsh-autosuggestions zsh-syntax-highlighting vi-mode kubectl)

# Disable auto-titling in omzsh
DISABLE_AUTO_TITLE="true"

# The bizness end of omzsh
source $ZSH/oh-my-zsh.sh
# }}}

# Utility functions {{{
command_exists() {
	test -x "$(command -v $1)" > /dev/null 2>&1
}
# }}}

# Setting up some environmental stuff {{{
# Vim is love, vim is life
export EDITOR=`which nvim`

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
export PATH=/usr/local/bin:$PATH
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

## vim -> nvim remap if available
if command_exists nvim; then
	alias vim='nvim'
fi

## Set up vimwiki usage
alias vw="cd ~/wiki/ && vim +VimwikiIndex && updatewiki"
alias diary="cd ~/wiki/ && vim +VimwikiMakeDiaryNote && updatewiki"
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

# support tmuxinator
if command_exists tmuxinator; then
	alias mux='tmuxinator'
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

