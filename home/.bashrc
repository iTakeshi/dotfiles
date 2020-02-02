# Use English UI
export LANG=en_US.utf8

# If not running interactively, don't do anything
case $- in
  *i*) ;;
    *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=10000
HISTFILESIZE=20000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto'
  alias dir='dir --color=auto'
  alias vdir='vdir --color=auto'

  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias lt='ls -alt'

alias grep='grep -i'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.gem/ruby/$(ruby -v | sed -e "s/^ruby \([0-9]\.[0-9]\+\).*$/\1.0/")/bin:$PATH"

GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true
GIT_PS1_SHOWSTASHSTATE=true
GIT_PS1_SHOWUPSTREAM="auto"
GIT_PS1_SHOWCOLORHINTS=true
GIT_COMPLETION_CHECKOUT_NO_GUESS=1
if [ -f /usr/share/git/completion/git-prompt.sh ]; then
    . /usr/share/git/completion/git-prompt.sh
    . /usr/share/git/completion/git-completion.bash
fi

__virtualenv_ps1() {
    if [[ -n "$VIRTUAL_ENV" ]]; then
        venv="${VIRTUAL_ENV%/.venv}"
        venv="${venv##*/}"
    else
        venv=''
    fi
    [[ -n "$venv" ]] && echo "(venv:$venv) "
}
. $HOME/dotfiles/scripts/poetry-completion.bash
_pip_completion()
{
    COMPREPLY=( $( COMP_WORDS="${COMP_WORDS[*]}" \
                   COMP_CWORD=$COMP_CWORD \
                   PIP_AUTO_COMPLETE=1 $1 ) )
}
complete -o default -F _pip_completion pip
export PYTHONSTARTUP=$HOME/dotfiles/scripts/startup.py
export VIRTUAL_ENV_DISABLE_PROMPT=1

if [ "$USER" = "itakeshi" ]; then
    PS1_USER=""
else
    PS1_USER="\[\033[1;36m\]\u\[\033[0m\]@"
fi
if [ "$SSH_CLIENT" = "" ]; then
    PS1_HOST="local"
else
    PS1_HOST="\[\033[1;31m\]\h\[\033[0m\]"
fi
PS1="$PS1_USER$PS1_HOST:\[\033[1;33m\]\w\$(__git_ps1) \[\033[1;35m\]\$ \$(__virtualenv_ps1)\[\033[0m\]"

export MANPAGER="/bin/sh -c \"col -b | nvim -c 'set ft=man ts=8 nomod nolist nonu noma' -\""

# use nvim everywhere
alias v=nvim
alias vi=nvim
alias vim=nvim
export EDITOR=nvim
export SYSTEMD_EDITOR=nvim

# lock
alias lock="light-locker-command -l"

alias checknoascii="grep --color='auto' -P -n \"[^\x00-\x7F]\""

# XDG Base Directory
# ref: https://wiki.archlinux.org/index.php/XDG_Base_Directory
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"

export HISTFILE="$XDG_DATA_HOME/bash/history"
export BUNDLE_USER_CONFIG="$XDG_CONFIG_HOME/bundle" BUNDLE_USER_CACHE="$XDG_CACHE_HOME/bundle" BUNDLE_USER_PLUGIN="$XDG_DATA_HOME/bundle"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export KAGGLE_CONFIG_DIR="$HOME/projects/kaggle"
export LESSHISTFILE=-
export MYCLI_HISTFILE="$XDG_DATA_HOME/mycli/history"
export NODE_REPL_HISTORY="$XDG_DATA_HOME/node/node_repl_history"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export WINEPREFIX="$XDG_DATA_HOME/wineprefixes/default"
export GOPATH="$HOME/projects/go"
export TMUX_TMPDIR="$XDG_RUNTIME_DIR"

export PATH="$GOPATH/bin:$PATH"

alias amm="amm -h $XDG_DATA_HOME/ammonite"
alias sbt="sbt -ivy $XDG_DATA_HOME/ivy2 -sbt-dir $XDG_DATA_HOME/sbt"
alias tmux="tmux -f "$XDG_CONFIG_HOME"/tmux/tmux.conf"
alias wget="wget --hsts-file=$XDG_DATA_HOME/wget-hsts"

export PYENV_ROOT="$XDG_DATA_HOME/pyenv"
export PATH="$PYENV_ROOT/bin:$HOME/.local/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
fi
export PIPX_HOME="$XDG_DATA_HOME/pipx"

# Load machine-specific config
if [ -f $HOME/.bashrc.local ]; then
    source $HOME/.bashrc.local
fi
