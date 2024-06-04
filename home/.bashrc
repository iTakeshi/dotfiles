# Use English UI
export LANG=en_US.UTF-8
export LC_ALL=$LANG
export LC_COLLATE=C

# If not running interactively, don't do anything
case $- in
  *i*) ;;
  *) return;;
esac

# don't put duplicate lines or lines starting with space in the history. See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000000
HISTFILESIZE=100000000

# check the window size after each command and, if necessary, update the values of LINES and COLUMNS.
shopt -s checkwinsize

###############################################################################
# Modernized Utilities
###############################################################################

if command -v nvim 1>/dev/null 2>&1; then
  alias vim=nvim
  export EDITOR=nvim
  export SYSTEMD_EDITOR=nvim
else
  alias vi=vim
  alias vim=vim
  export EDITOR=vim
  export SYSTEMD_EDITOR=vim
fi

if command -v bat 1>/dev/null 2>&1; then
  alias cat="bat"
fi

if command -v eza 1>/dev/null 2>&1; then
  alias ls="eza"
  alias ll="eza -alF"
  alias lt="eza -alF -s modified"
else
  alias ls="ls --color=auto"
  alias ll="ls --color=auto -alF"
  alias lt="ls --color=auto -alFt"
fi

alias scp="echo -e \"scp is officially deprecated. use rsync instead.\n\""

###############################################################################
# MISC Aliases
###############################################################################
#
alias checknoascii="grep --color='auto' -P -n \"[^\x00-\x7F]\""

if command -v xset 1>/dev/null 2>&1; then
  alias disable_sleep="xset s off -dpms"
  alias display_off="xset dpms force off"
fi

alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

###############################################################################
# XDG Base Directory
# ref: https://wiki.archlinux.org/index.php/XDG_Base_Directory
###############################################################################

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"

export HISTFILE="$XDG_DATA_HOME/bash/history"
export LESSHISTFILE=-
export NODE_REPL_HISTORY="$XDG_DATA_HOME/node/node_repl_history"
export MYCLI_HISTFILE="$XDG_DATA_HOME/mycli/history"

export BUNDLE_USER_CONFIG="$XDG_CONFIG_HOME/bundle" BUNDLE_USER_CACHE="$XDG_CACHE_HOME/bundle" BUNDLE_USER_PLUGIN="$XDG_DATA_HOME/bundle"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/rustup"
export KAGGLE_CONFIG_DIR="$HOME/projects/kaggle"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export WINEPREFIX="$XDG_DATA_HOME/wineprefixes/default"
export GOPATH="$HOME/projects/go"
export TMUX_TMPDIR="$XDG_RUNTIME_DIR"
export RLWRAP_HOME="$XDG_DATA_HOME/rlwrap"

alias amm="amm -h $XDG_DATA_HOME/ammonite"
alias sbt="sbt -ivy $XDG_DATA_HOME/ivy2 -sbt-dir $XDG_DATA_HOME/sbt"
alias tmux="tmux -f "$XDG_CONFIG_HOME"/tmux/tmux.conf"
alias wget="wget --hsts-file=$XDG_DATA_HOME/wget-hsts"

export PATH="$HOME/.local/bin:$PATH"

###############################################################################
# Language Version Managers
###############################################################################

export PYENV_ROOT="$XDG_DATA_HOME/pyenv"
export POETRY_HOME="$XDG_DATA_HOME/poetry"
export PATH="$POETRY_HOME/bin:$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
fi

export PATH="$HOME/.rbenv/shims:$PATH"
if command -v rbenv 1>/dev/null 2>&1; then
  eval "$(rbenv init -)"
fi

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

###############################################################################
# MISC ENV
###############################################################################

export DOCKER_BUILDKIT=1

if command -v bat 1>/dev/null 2>&1; then
  export MANROFFOPT="-c"
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
fi

export PYTHONSTARTUP=$HOME/dotfiles/scripts/startup.py

###############################################################################
# Auto-Completion
###############################################################################

if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  elif [ -f /usr/local/etc/bash_completion ]; then
    . /usr/local/etc/bash_completion
  fi
fi

GIT_COMPLETION_CHECKOUT_NO_GUESS=1
if [ -f /usr/share/git/completion/git-prompt.sh ]; then
  . /usr/share/git/completion/git-prompt.sh
  . /usr/share/git/completion/git-completion.bash
elif [ -f /usr/local/etc/bash_completion.d/git-prompt.sh ]; then
  . /usr/local/etc/bash_completion.d/git-prompt.sh
  . /usr/local/etc/bash_completion.d/git-completion.bash
fi

. $HOME/dotfiles/scripts/poetry-completion.bash

_pip_completion() {
  COMPREPLY=( $( COMP_WORDS="${COMP_WORDS[*]}" \
    COMP_CWORD=$COMP_CWORD \
    PIP_AUTO_COMPLETE=1 $1 ) )
}
complete -o default -F _pip_completion pip

if command -v aws_completer 1>/dev/null 2>&1; then
  complete -C 'aws_completer' aws
fi

###############################################################################
# PS1
###############################################################################

GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true
GIT_PS1_SHOWSTASHSTATE=true
GIT_PS1_SHOWUPSTREAM="auto"
GIT_PS1_SHOWCOLORHINTS=true

__virtualenv_ps1() {
  if [[ -n "$VIRTUAL_ENV" ]]; then
    venv="${VIRTUAL_ENV%/.venv}"
    venv="${venv##*/}"
  else
    venv=''
  fi
  [[ -n "$venv" ]] && echo "(venv:$venv) "
}

export VIRTUAL_ENV_DISABLE_PROMPT=1

if [ "$USER" = "itakeshi" ]; then
  PS1_USER=""
else
  PS1_USER="\[\e[1;36m\]\u\[\e[0m\]@"
fi
if [ "$SSH_CLIENT" = "" ]; then
  PS1_HOST="local"
else
  PS1_HOST="\[\e[1;31m\]\h\[\e[0m\]"
fi
if [ "$AWS_PROFILE" != "" ]; then
  PS1_AWS=" \[\e[1;31m\]($AWS_PROFILE@$AWS_DEFAULT_REGION)\[\e[0m\]"
else
  PS1_AWS=""
fi
PS1="\$(date "+%H:%M:%S") $PS1_USER$PS1_HOST:\[\e[1;33m\]\w\[\e[0m\]\$(__git_ps1)$PS1_AWS \[\e[1;35m\]\$ \[\e[0;35m\]\$(__virtualenv_ps1)\[\e[0m\]"

###############################################################################
# Load Machine-Specific Config
###############################################################################

if [ -f $HOME/.bashrc.local ]; then
  source $HOME/.bashrc.local
fi
