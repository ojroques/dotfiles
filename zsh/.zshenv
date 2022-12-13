# XDG
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# EDITOR
export EDITOR="vim"
export VISUAL="nvim"
export SUDO_EDITOR="vim"

# APPS
export BAT_THEME="OneHalfDark"
export FZF_DEFAULT_COMMAND="rg --files --hidden --glob '!.git'"
export LESS="--raw-control-chars"

# LESS COLORS
export LESS_TERMCAP_mb=$'\e[1;31m'
export LESS_TERMCAP_md=$'\e[1;33m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[100m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[4;34m'

# ZSH
ZDOTDIR="$XDG_CONFIG_HOME/zsh"
HISTFILE="$XDG_STATE_HOME/zsh/history"
HISTORY_IGNORE="(cd|clear|exit|ls|pwd)"
HISTSIZE=10000
SAVEHIST=10000

# FPATH
typeset -U fpath
fpath=("$XDG_DATA_HOME/zsh/functions" "$XDG_DATA_HOME/zsh/prompt" $fpath)

# PATH
typeset -U path
path=("$HOME/.local/bin" "$HOME/go/bin" "/usr/local/go/bin" $path)
export PATH
