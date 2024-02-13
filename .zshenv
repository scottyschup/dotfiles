#!/bin/zsh

# From 8b installation
source /opt/homebrew/opt/chruby/share/chruby/chruby.sh
source /opt/homebrew/opt/chruby/share/chruby/auto.sh
[ -d "$HOME/code/8b/bin" ] && export PATH="$HOME/code/8b/bin:$PATH"
export GOPATH=$HOME/go
