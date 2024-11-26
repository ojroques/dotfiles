# ZSH OPTIONS
bindkey -e
setopt glob_dots
setopt hist_ignore_all_dups
setopt hist_reduce_blanks
setopt no_auto_menu
setopt share_history

# ZSH PARAMETERS
HISTFILE="$XDG_STATE_HOME/zsh/history"
HISTORY_IGNORE="(cd|dl|doc|ls|t|tmp|up|wk)"
HISTSIZE=10000
SAVEHIST=10000

# FPATH
typeset -U fpath
fpath=("$XDG_DATA_HOME/zsh/functions" "$XDG_DATA_HOME/zsh/prompt" $fpath)

# PATH
typeset -U path
path=("$HOME/.local/bin" "$HOME/go/bin" "/usr/local/go/bin" $path)
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
alias df='df -Th --total'
alias diff='diff -su --color=auto'
alias dl="cd $HOME/Downloads"
alias doc="cd $HOME/Documents"
alias du='du -ch'
alias e="$VISUAL"
alias g='git'
alias grep='grep --color=auto'
alias ip='ip -c -h'
alias ll='ls -lAh'
alias ls='ls -F --color=auto --group-directories-first'
alias py='python3'
alias t='tmux'
alias tmp="cd $HOME/.tmp"
alias tree='tree -FC --dirsfirst -I .git'
alias wk="cd $HOME/Work"

# APP PARAMETERS
export BAT_THEME="OneHalfDark"
export MANPAGER='nvim --appimage-extract-and-run +Man!'
export RIPGREP_CONFIG_PATH="$XDG_CONFIG_HOME/ripgrep/config"

# EXTERNAL SOURCES
[[ -r "$HOME/.env" ]] && source "$HOME/.env"
[[ -r "$HOME/.fzf-git/fzf-git.sh" ]] && source "$HOME/.fzf-git/fzf-git.sh"
[[ -r "$XDG_CONFIG_HOME/fzf/fzf.zsh" ]] && source "$XDG_CONFIG_HOME/fzf/fzf.zsh"
[[ -r /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
[[ -x /usr/bin/dircolors ]] && eval "$(dircolors -b)"
[[ -x /usr/bin/direnv ]] && eval "$(direnv hook zsh)"
[[ -x /usr/bin/kubectl ]] && eval "$(kubectl completion zsh)"
