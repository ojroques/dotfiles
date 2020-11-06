# bash config
# github.com/ojroques

# Exit if not running interactively
case $- in
  *i*) ;;
  *) return;;
esac

export EDITOR="nvim"
export VISUAL="$EDITOR"
export PAGER="less"
export MANPAGER="less -s -M +Gg"
export HISTCONTROL="ignoreboth:erasedups"
export HISTIGNORE="cd:ls:pwd:clear:exit"
export HISTSIZE=1000
export PROMPT_COMMAND="history -a; history -c; history -r"
export FZF_DEFAULT_COMMAND="rg --files"
export BAT_THEME="OneHalfDark"

shopt -s histappend
shopt -s checkwinsize

# Make less more friendly for non-text input files
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# Enable color support of ls
if [ -x /usr/bin/dircolors ]; then
  [ -r ~/.dircolors ] && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

# Enable completion
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    source /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    source /etc/bash_completion
  fi
fi

# Set prompt
export PS1="\u@\h:\w\$"
case "$TERM" in
  xterm-color|*-256color)
    if [ -r .shell/prompt ]; then
      source .shell/prompt
      PS1="\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[01;33m\]\$(parse_git status)\[\033[00m\]\$ "
    fi
    ;;
esac

[ -r .shell/aliases ] && source .shell/aliases
[ -r .shell/functions ] && source .shell/functions
[ -r .shell/less ] && source .shell/less
