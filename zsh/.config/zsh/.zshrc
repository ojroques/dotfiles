# ZSH OPTIONS
setopt glob_dots
setopt hist_ignore_all_dups
setopt hist_reduce_blanks
setopt no_auto_menu
setopt share_history

# ZSH PARAMETERS
HISTFILE="$XDG_STATE_HOME/zsh/history"
HISTORY_IGNORE="(cd|dl|doc|e|ll|ls|py|t|tmp|up|upr|wk)"
HISTSIZE=10000
SAVEHIST=10000

# ZLE
function zle-line-init zle-keymap-select {
  case $KEYMAP in
    vicmd) printf "\e[2 q";; # steady block
    main) printf "\e[6 q";;  # steady bar
  esac
}
autoload -Uz edit-command-line
zle -N edit-command-line
zle -N zle-keymap-select
zle -N zle-line-init
bindkey -v
bindkey -M main '\e.' insert-last-word
bindkey -M main '^n' down-history
bindkey -M main '^p' up-history
bindkey -M main '^x^e' edit-command-line
bindkey -M main 'jj' vi-cmd-mode

# FPATH
typeset -U fpath
fpath=("$XDG_DATA_HOME/zsh/functions" "$XDG_DATA_HOME/zsh/prompt" $fpath)

# PATH
typeset -U path
path=("$XDG_BIN_HOME" "$HOME/go/bin" "/usr/local/go/bin" "$HOME/.node_modules/bin" $path)
export PATH

# GIT
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr '='
zstyle ':vcs_info:git:*' unstagedstr '~'
zstyle ':vcs_info:git:*' formats '(%b)%c%u'
zstyle ':vcs_info:git:*' actionformats '(%b)%c%u %a'

# PROMPT
autoload -Uz promptinit
promptinit
prompt personal

# COMPLETION
autoload -Uz compinit
compinit
zstyle ':completion:*' completer _expand _complete
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-dirs-first true
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:descriptions' format '%F{magenta}-- %d --%f'
zstyle ':completion:*:warnings' format '%F{yellow}-- %d --%f'

# FUNCTIONS
autoload -Uz "$XDG_DATA_HOME/zsh/functions"/*(:t)

# CDR
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd cdls
add-zsh-hook chpwd chpwd_recent_dirs

# EDITOR
export EDITOR="vim"
export VISUAL="nvim"
export SUDO_EDITOR="vim"

# ALIASES
alias df='df -TH'
alias diff='diff -su --color=auto'
alias dl="cd $HOME/Downloads"
alias doc="cd $HOME/Documents"
alias du1='du --si --max-depth=1 --time | sort -hr'
alias e="$VISUAL"
alias g='git'
alias grep='grep --color=auto'
alias ip='ip -h --color=auto'
alias ll='ls -lAh'
alias ls='ls -F --group-directories-first --color=auto'
alias py='python3'
alias t='tmux'
alias tmp="cd $HOME/.tmp"
alias tree='tree -FC --dirsfirst -I .git'
alias wk="cd $HOME/Work"

# APP PARAMETERS
export BAT_THEME="OneHalfDark"
export MANPAGER='nvim +Man!'
export NPM_CONFIG_PREFIX="$HOME/.node_modules"
export RIPGREP_CONFIG_PATH="$XDG_CONFIG_HOME/ripgrep/config"

# EXTERNAL SOURCES
[[ -x /usr/bin/dircolors ]] && eval "$(dircolors -b)" || true
[[ -x /usr/bin/direnv ]] && eval "$(direnv hook zsh)" || true
[[ -r /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh || true
[[ -r "$XDG_CONFIG_HOME/fzf/fzf.zsh" ]] && source "$XDG_CONFIG_HOME/fzf/fzf.zsh" || true
[[ -r "$HOME/.fzf-git/fzf-git.sh" ]] && source "$HOME/.fzf-git/fzf-git.sh" || true
[[ -r "$XDG_CONFIG_HOME/zsh/.env" ]] && source "$XDG_CONFIG_HOME/zsh/.env" || true
[[ -r "$XDG_CONFIG_HOME/zsh/.run" ]] && source "$XDG_CONFIG_HOME/zsh/.run" || true
