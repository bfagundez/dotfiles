# aliases
alias vim="nvim"
# paths
export PATH="$PATH:/usr/local/Cellar/graphviz/2.40.1/bin"
# NVM
export NVM_DIR="$HOME/.nvm"
. "/usr/local/opt/nvm/nvm.sh"
# RBENV
eval "$(rbenv init -)"

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi
