#!/bin/zsh

export DOTFILES=$HOME/.dotfiles

# From 8b installation
source /opt/homebrew/opt/chruby/share/chruby/chruby.sh
source /opt/homebrew/opt/chruby/share/chruby/auto.sh
[ -d "/Users/sscottschupbach/code/8b/bin" ] && export PATH="/Users/sscottschupbach/code/8b/bin:$PATH"
export GOPATH=$HOME/go

echo 'Sourced .zshenv'
