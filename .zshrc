# aliases
alias vim="nvim"
alias dc="docker-compose"
# paths
export PATH="$PATH:/usr/local/Cellar/graphviz/2.40.1/bin"
export PATH="$PATH:~/Library/Python/3.7/bin"
export PATH="$PATH:~/flutter/bin"
export EDITOR="nvim"
# NVM
#export NVM_DIR="$HOME/.nvm"
#. "/usr/local/opt/nvm/nvm.sh"
# RBENV
eval "$(rbenv init -)"
# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

prompt_context() {
  # local user=`whoami`

  # if [[ "$user" != "$DEFAULT_USER" || -n "$SSH_CONNECTION" ]]; then
  #   prompt_segment $PRIMARY_FG default " %(!.%{%F{yellow}%}.)$user@%m "
  # fi

  prompt_segment $PRIMARY_FG default  " 🤖 "
}

prompt_dir() {
  prompt_segment blue $PRIMARY_FG ' %c '
}


export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
