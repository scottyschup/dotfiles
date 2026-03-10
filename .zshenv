#!/bin/zsh

# Keep non-interactive shells observable; avoid global redirection here.

{
  export DOTFILES=$HOME/.dotfiles
  export GITHUB_HOST=github.com
  export GITHUB_HOST_PERSONAL=github.com.personal

  export PATH="$DOTFILES/scripts:$PATH"
  [ -d "$HOME/code/8b/bin" ] && export PATH="$HOME/code/8b/bin:$PATH"
  export GOPATH=$HOME/go

  # Color shortcuts
  source "$DOTFILES/.colors"

  # Custom functions
  source "$DOTFILES/.git_functions"
  source "$DOTFILES/.functions"

  # From 8b installation
  if command -v chruby >/dev/null 2>&1; then
    source /opt/homebrew/opt/chruby/share/chruby/chruby.sh
    source /opt/homebrew/opt/chruby/share/chruby/auto.sh
  fi

  # migrating to asdf
  if [[ ! -o interactive ]]; then
    if command -v asdf >/dev/null 2>&1; then
      source "$(brew --prefix asdf)/libexec/asdf.sh"
    fi
  fi
}
