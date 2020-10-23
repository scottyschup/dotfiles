#!/bin/zsh

# Add rbenv/pyenv/npm bin to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$(npm bin):$PATH"
export PATH="$HOME/.pyenv/bin:$PATH"
export PATH="$HOME/.rbenv/bin:$PATH"

echo 'Sourced .zshenv'
