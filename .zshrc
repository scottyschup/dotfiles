export ZSH=~/.oh-my-zsh
ZSH_THEME="robbyrussell"
DISABLE_AUTO_UPDATE="true"
DISABLE_AUTO_TITLE="true"
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
HIST_STAMPS="mm/dd/yyyy"
plugins=(git atom ruby colorize rails z)
source $ZSH/oh-my-zsh.sh
source ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.k.sh
source $DOTFILES/.aliases
source $DOTFILES/.functions
source $DOTFILES/custom_zsh_tabs.sh

export LANG=en_US.UTF-8
export PATH="~/.rbenv/bin:~/.rbenv/shims:$PATH"
eval "$(rbenv init -)"
