#!/bin/zsh

# Keep non-interactive shells observable; avoid global redirection here.

# Initialize version manager FIRST, before anything else
if [[ -f /opt/homebrew/opt/asdf/libexec/asdf.sh ]]; then
  . /opt/homebrew/opt/asdf/libexec/asdf.sh
elif command -v chruby >/dev/null 2>&1; then
  source /opt/homebrew/opt/chruby/share/chruby/chruby.sh
  source /opt/homebrew/opt/chruby/share/chruby/auto.sh
fi

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
}
