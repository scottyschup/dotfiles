#!/bin/zsh

[ -d "$HOME/code/8b/bin" ] && export PATH="$HOME/code/8b/bin:$PATH"
export GOPATH=$HOME/go

# From 8b installation
if [[ `which chruby` != *"not found" ]]; then
  source /opt/homebrew/opt/chruby/share/chruby/chruby.sh
  source /opt/homebrew/opt/chruby/share/chruby/auto.sh
fi
# migrating to asdf
if [[ `which asdf` != *"not found" ]]; then
  source $(brew --prefix asdf)/libexec/asdf.sh
  echo 'asdf initialized' && asdf current
fi

echo 'Sourced .zshenv'
