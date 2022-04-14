#!/bin/zsh

# Functions
source $DOTFILES/.git_functions
source $DOTFILES/.functions

# Aliases
source $DOTFILES/.aliases

# Scripts
export PATH="$DOTFILES/scripts:$PATH"
(for file in $(ls -A "$DOTFILES/scripts"); do
  chmod +x "$DOTFILES/scripts/$file"
done &&
  echo 'Sourced scripts/* and appended dir to PATH') ||
  echo 'Something happened :/ ^^^'

# Aliases that depend on scripts
source $DOTFILES/.aliases-post-scripts

echo 'Sourced .zshenv'
