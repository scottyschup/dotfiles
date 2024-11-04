#!/bin/zsh

# From 8b installation
if [[ `which chruby` != *"not found" ]]; then
  source /opt/homebrew/opt/chruby/share/chruby/chruby.sh
  source /opt/homebrew/opt/chruby/share/chruby/auto.sh
fi
[ -d "$HOME/code/8b/bin" ] && export PATH="$HOME/code/8b/bin:$PATH"
export GOPATH=$HOME/go

echo 'Sourced .zshenv'
