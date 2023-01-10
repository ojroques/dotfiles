# Colors
[[ -x /usr/bin/dircolors ]] && eval "$(dircolors -b)"

# Options
bindkey -e
setopt glob_dots
setopt hist_ignore_all_dups
setopt hist_reduce_blanks
setopt no_auto_menu
setopt share_history

# VCS
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr '='
zstyle ':vcs_info:git:*' unstagedstr '~'
zstyle ':vcs_info:git:*' formats '(%b)%c%u'
zstyle ':vcs_info:git:*' actionformats '(%b)%c%u %a'

# Prompt
autoload -Uz promptinit
promptinit
prompt personal

# Completion
autoload -Uz compinit
compinit
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' group-name ''
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*:descriptions' format '%F{magenta}-- %d --%f'
zstyle ':completion:*:corrections' format '%F{yellow}-- %d (errors: %e) --%f'
zstyle ':completion:*:warnings' format '%F{red}-- no matches --%f'
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

# CDR
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs

# Functions
autoload -Uz apt-clean
autoload -Uz apt-list
autoload -Uz apt-update
autoload -Uz cheat
autoload -Uz rm-swap
autoload -Uz up

# Aliases
alias df='df -Th --total'
alias diff='diff -su --color=auto'
alias dl="cd $HOME/Downloads && ls"
alias doc="cd $HOME/Documents && ls"
alias du='du -ch'
alias dua='du -a --max-depth=1 | sort -hr'
alias e="$VISUAL"
alias g='git'
alias gdiff="nvim -c '0Git log --oneline --decorate'"
alias grep='grep --color=auto'
alias h="cd $HOME && ls"
alias ip='ip -ch'
alias ll='ls -lAh'
alias ls='ls -F --color=auto --group-directories-first'
alias py='python3'
alias t='tmux'
alias tmp="cd $HOME/.tmp && ls"
alias tree='tree -FC --dirsfirst'

# FZF
[[ -f ~/.fzf.zsh ]] && source ~/.fzf.zsh
