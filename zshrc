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
ZSH_THEME="mh"

# The most basic set of plugins possible. I don't need a lot :)
plugins=(git docker virtualenv tmuxinator)

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
export EDITOR='/usr/local/bin/vim'

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

# Custom macros {{{
# Note taking {{{
#
# Summary: run `note <title>` to make a new note
#          run `notes` to get a fuzzy finder (if available) to view all notes
function note() {
	NOTE_DIR=~/Dropbox/notes
	mkdir -p $NOTE_DIR || true
	NOTE_NAME="$1"
	if [[ -z $NOTE_NAME ]]; then
		NOTE_NAME="$(date +%Y-%m-%d)"
	else
		NOTE_NAME="$(date +%Y-%m-%d)-$NOTE_NAME"
	fi
	vim $NOTE_DIR/$NOTE_NAME.txt
}

function notes() {
	NOTE_DIR=~/Dropbox/notes
	mkdir -p $NOTE_DIR || true
	pushd $NOTE_DIR > /dev/null
	# Use the fuzzy finder if available
	if command_exists fzf; then
		# Only open the selection if one was actually chosen
		NOTEFILE=$(find * -type f -maxdepth 0 | fzf)
		if [[ -n $NOTEFILE ]]; then
			vim $NOTEFILE
		fi
	else
		vim .
	fi
	popd > /dev/null
}
# }}}
# }}}

# Extra path manipulation {{{
# Add /usr/local/bin to the path
export PATH=/usr/local/bin:$PATH
# Add $HOME/bin to the path
export PATH=$HOME/bin:$PATH
# }}}

# Source a local .zshrc if available, for machine-specific stuff {{{
if [ -f $HOME/.zshrc.local ]; then
	source $HOME/.zshrc.local
fi
# }}}

# Some extra custom functions {{{
alias servedir='python -mSimpleHTTPServer 8080'
alias c='clear'

# vim -> nvim remap if available
if command_exists nvim; then
	alias vim='nvim'
fi

# support tmuxinator
if command_exists tmuxinator; then
	alias mux='tmuxinator'
fi
# }}}
