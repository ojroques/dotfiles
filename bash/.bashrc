# bash config
# github.com/ojroques

export BAT_THEME="OneHalfDark"
export EDITOR="nvim"
export FZF_DEFAULT_COMMAND="rg --files --hidden -g '!.git/'"
export HISTCONTROL="ignoreboth:erasedups"
export HISTIGNORE="cd:ls:pwd:clear:exit"
export HISTSIZE=1000
export PROMPT_COMMAND="history -a; history -c; history -r"
export PS1="\u@\h:\w\$ "
export VISUAL="$EDITOR"

shopt -s dotglob
shopt -s histappend

# Make less more friendly for non-text input files
[[ -x /usr/bin/lesspipe ]] && eval "$(SHELL=/bin/sh lesspipe)"

# Enable color support for ls
if [[ -x /usr/bin/dircolors ]]; then
  [[ -f ~/.dircolors ]] && eval "$(dircolors -b ~/.dircolors)"
fi

# Enable completion
if ! shopt -oq posix; then
  if [[ -f /usr/share/bash-completion/bash_completion ]]; then
    source /usr/share/bash-completion/bash_completion
  elif [[ -f /etc/bash_completion ]]; then
    source /etc/bash_completion
  fi
fi

# Set colored prompt
if [[ -x /usr/bin/tput ]] && tput setaf 1 &> /dev/null; then
  PS1="\[\e[1;32m\]\u@\h\[\e[0m\]:\[\e[1;34m\]\w\[\e[0m\]\$ "
  if [[ -f ~/.shell/prompt ]]; then
    source ~/.shell/prompt
    PS1="\[\e[1;32m\]\u@\h\[\e[0m\]:\[\e[1;34m\]\w\[\e[1;33m\]\$(parse_git status)\[\e[0m\]\$ "
  fi
fi

# Set WSL environment variables
if grep -q -i "microsoft" /proc/sys/kernel/osrelease; then
  export DISPLAY="localhost:0.0"
  [[ -f ~/.shell/ssh-agent ]] && source ~/.shell/ssh-agent
  if [[ ! -f ~/.shell/wsl.env ]]; then
    mkdir -p ~/.shell
    echo "WSL_HOME=$(wslpath "$(wslvar USERPROFILE)")" > ~/.shell/wsl.env
  fi
  source ~/.shell/wsl.env
fi

[[ -f ~/.shell/aliases ]] && source ~/.shell/aliases
[[ -f ~/.shell/functions ]] && source ~/.shell/functions
[[ -f ~/.shell/less ]] && source ~/.shell/less
