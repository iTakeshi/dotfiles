###############################################################################
# Locale
###############################################################################

export LANG=en_US.UTF-8
export LC_ALL=$LANG
export LC_COLLATE=C

###############################################################################
# XDG Base Directory (set first — used by Oh My Zsh path and history)
###############################################################################

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_BIN_HOME="$HOME/.local/bin"
export XDG_DATA_HOME="$HOME/.local/share"

###############################################################################
# Oh My Zsh
###############################################################################

export ZSH="$XDG_DATA_HOME/oh-my-zsh"
ZSH_COMPDUMP="$XDG_CACHE_HOME/zsh/zcompdump"
ZSH_THEME="itakeshi"
plugins=(aws git mise poetry uv)
source $ZSH/oh-my-zsh.sh

###############################################################################
# History (override Oh My Zsh defaults)
###############################################################################

HISTFILE="$XDG_DATA_HOME/zsh/history"
HISTSIZE=1000000
SAVEHIST=100000000

###############################################################################
# XDG-compliant app data paths and PATH
###############################################################################

export LESSHISTFILE=-
export NODE_REPL_HISTORY="$XDG_DATA_HOME/node/node_repl_history"
export PYTHON_HISTORY="$XDG_DATA_HOME/python/history"
export CARGO_HOME="$XDG_DATA_HOME/rust/cargo"
export RUSTUP_HOME="$XDG_DATA_HOME/rust/rustup"

export BUN_INSTALL="$XDG_DATA_HOME/bun"
export PNPM_HOME="$XDG_DATA_HOME/pnpm"

export CLAUDE_CONFIG_DIR="$XDG_CONFIG_HOME/claude"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export POETRY_CONFIG_DIR="$XDG_CONFIG_HOME/pypoetry"

export PATH="$PNPM_HOME:$BUN_INSTALL/bin:$CARGO_HOME/bin:$HOME/.local/bin:$PATH"
eval "$(mise activate zsh)"

###############################################################################
# MISC ENV
###############################################################################

if command -v bat &>/dev/null; then
  export MANROFFOPT="-c"
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
fi

###############################################################################
# Modernized Utilities
###############################################################################

if command -v nvim &>/dev/null; then
  alias vim=nvim
  export EDITOR=nvim
  export SYSTEMD_EDITOR=nvim
else
  alias vi=vim
  export EDITOR=vim
  export SYSTEMD_EDITOR=vim
fi

command -v bat &>/dev/null && alias cat="bat"

if command -v eza &>/dev/null; then
  alias ls="eza --sort=Name --group-directories-first"
  alias ll="eza -almUF --sort=Name --group-directories-first"
  alias lt="eza -almUF -s modified"
else
  alias ls="ls --color=auto"
  alias ll="ls --color=auto -alF"
  alias lt="ls --color=auto -alFt"
fi

alias scp='echo "scp is officially deprecated. use rsync instead."'

###############################################################################
# MISC Aliases
###############################################################################

alias checknoascii="grep --color='auto' -P -n '[^\x00-\x7F]'"

# fc -ln -1 gives the last command without history number (zsh equivalent of
# bash's history|tail -n1|sed ...)
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(fc -ln -1)"'

###############################################################################
# Load Machine-Specific Config
###############################################################################

[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"
