# ZSH OPTIONS
bindkey -e
setopt glob_dots
setopt hist_ignore_all_dups
setopt hist_reduce_blanks
setopt no_auto_menu
setopt share_history

# ZSH PARAMETERS
HISTFILE="$XDG_STATE_HOME/zsh/history"
HISTORY_IGNORE="(cd|clear|dl|doc|exit|ll|ls|pwd|t|tmp|up|wk)"
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

# FUNCTIONS
autoload -Uz apt-autoremove
autoload -Uz apt-upgrade
autoload -Uz cheat
autoload -Uz rm-swap
autoload -Uz up

# EDITOR
export EDITOR="vim"
export VISUAL="nvim"
export SUDO_EDITOR="vim"

# ALIASES
alias df='df -Th --total'
alias diff='diff -su --color=auto'
alias dl="cd $HOME/Downloads && ls"
alias doc="cd $HOME/Documents && ls"
alias du='du -ch'
alias dua='du -a --max-depth=1 | sort -hr'
alias e="$VISUAL"
alias g='git'
alias grep='grep --color=auto'
alias ip='ip -c -h'
alias ll='ls -lAh'
alias ls='ls -F --color=auto --group-directories-first'
alias py='python3'
alias t='tmux'
alias tmp="cd $HOME/.tmp && ls"
alias tree='tree -FC --dirsfirst -I .git'
alias wk="cd $HOME/Work && ls"

# APP PARAMETERS
export BAT_THEME="OneHalfDark"
export FZF_ALT_C_COMMAND="cdr -l | awk '{print \$2}' | sed 's?~?$HOME?g'"
export MANPAGER='nvim +Man!'
export RIPGREP_CONFIG_PATH="$XDG_CONFIG_HOME/ripgrep/config"

# EXTERNAL SOURCES
[[ -r "$HOME/.env" ]] && source "$HOME/.env"
[[ -r /usr/share/doc/fzf/examples/key-bindings.zsh ]] && source /usr/share/doc/fzf/examples/key-bindings.zsh
[[ -r /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
[[ -x /usr/bin/dircolors ]] && eval "$(dircolors -b)"
[[ -x /usr/bin/direnv ]] && eval "$(direnv hook zsh)"
