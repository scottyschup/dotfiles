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
export GOROOT=/usr/local/go
export GOPATH=$HOME/Documents/github/go:$GOROOT
export PATH=$PATH:$GOROOT/bin:/usr/local/opt/go/libexec/bin # add Go
export PATH=~/.rbenv/bin:~/.rbenv/shims:$PATH:~/bin
eval "$(rbenv init -)"

# Use Keypad in terminal
# 0 . Enter
bindkey -s "^[Op" "0"
bindkey -s "^[On" "."
bindkey -s "^[OM" "^M"
# 1 2 3
bindkey -s "^[Oq" "1"
bindkey -s "^[Or" "2"
bindkey -s "^[Os" "3"
# 4 5 6
bindkey -s "^[Ot" "4"
bindkey -s "^[Ou" "5"
bindkey -s "^[Ov" "6"
# 7 8 9
bindkey -s "^[Ow" "7"
bindkey -s "^[Ox" "8"
bindkey -s "^[Oy" "9"
# + -  * /
bindkey -s "^[Ok" "+"
bindkey -s "^[Om" "-"
bindkey -s "^[Oj" "*"
bindkey -s "^[Oo" "/"
bindkey -s "^[OX" "="
