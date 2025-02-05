#!/bin/zsh

{
  export DOTFILES=$HOME/.dotfiles
  export GITHUB_HOST=github.com
  export GITHUB_HOST_PERSONAL=github.com.personal

  [ -d "$HOME/code/8b/bin" ] && export PATH="$HOME/code/8b/bin:$PATH"
  export GOPATH=$HOME/go

  # Color shortcuts
  source $DOTFILES/.colors

  # Custom functions
  source $DOTFILES/.git_functions
  source $DOTFILES/.functions

  # From 8b installation
  if [[ `which chruby` != *"not found" ]]; then
    source /opt/homebrew/opt/chruby/share/chruby/chruby.sh
    source /opt/homebrew/opt/chruby/share/chruby/auto.sh
  fi
  # migrating to asdf
  if [[ `which asdf` != *"not found" ]]; then
    source $(brew --prefix asdf)/libexec/asdf.sh
    echo "asdf$GRN initialized$NONE"
  fi

  echo "$GRN""Sourced$NONE .zshenv"
} >/dev/null # Suppress output so non-interactive shells don't see it
