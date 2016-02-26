export ZSH=~/.oh-my-zsh
ZSH_THEME="robbyrussell"
DISABLE_AUTO_UPDATE="true"
DISABLE_AUTO_TITLE="true"
ENABLE_CORRECTION="false" # this prevents zsh from offering spelling corrections to 'mistyped' commands
COMPLETION_WAITING_DOTS="true"
HIST_STAMPS="mm/dd/yyyy"
plugins=(atom colorize git k rails ruby z zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh
source $DOTFILES/.aliases
source $DOTFILES/.functions
source $DOTFILES/custom_zsh_tabs.sh # this should go into zsh_custom/plugins
export LANG=en_US.UTF-8
export PATH="~/.rbenv/bin:~/.rbenv/shims:$PATH"
eval "$(rbenv init -)"
