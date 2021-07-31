# bash config
# github.com/ojroques

BASH_DIR="$HOME/.local/share/bash"

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
  PS1="\[\e[32m\]\u@\h\[\e[0m\]:\[\e[1;34m\]\w\[\e[0m\]\$ "
  if [[ -f $BASH_DIR/prompt ]]; then
    source $BASH_DIR/prompt
    PS1="\[\e[32m\]\u@\h\[\e[0m\]:\[\e[1;34m\]\w\[\e[0;33m\]\$(parse_git status)\[\e[0m\]\$ "
  fi
fi

# Set WSL environment variables
if grep -q -i "microsoft" /proc/sys/kernel/osrelease; then
  export DISPLAY="localhost:0.0"
  export PROMPT_COMMAND=$PROMPT_COMMAND'; printf "\e]9;9;%s\e\\" "$(wslpath -m "$PWD")"'
  [[ -f $BASH_DIR/ssh-agent ]] && source $BASH_DIR/ssh-agent
  if [[ ! -f $BASH_DIR/wsl.env ]]; then
    mkdir -p $BASH_DIR
    echo "WSL_HOME=$(wslpath "$(wslvar USERPROFILE)")" > $BASH_DIR/wsl.env
  fi
  source $BASH_DIR/wsl.env
fi

# Go environment
export PATH=$PATH:/usr/local/go/bin:/usr/local/protobuf/bin:~/go/bin

[[ -f $BASH_DIR/aliases ]] && source $BASH_DIR/aliases
[[ -f $BASH_DIR/functions ]] && source $BASH_DIR/functions
[[ -f $BASH_DIR/less ]] && source $BASH_DIR/less
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
