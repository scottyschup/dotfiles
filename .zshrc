#!/usr/bin/zsh -w

# For compilers to find openssl@1.1
export LDFLAGS="-L/usr/local/opt/openssl@1.1/lib"
export CFLAGS="-I/usr/local/opt/openssl@1.1/include"
export CPPFLAGS="-I/usr/local/opt/openssl@1.1/include"

# For pkg-config to find openssl@1.1
export PKG_CONFIG_PATH="/usr/local/opt/openssl@1.1/lib/pkgconfig"

export DOTFILES=$HOME/.dotfiles
export GITHUB_HOST=github.com
export GITHUB_HOST_PERSONAL=github.com.personal
export ZSH=~/.oh-my-zsh # or wherever your oh-my-zsh installation lives
ZSH_THEME="robbyrussell"
DISABLE_AUTO_UPDATE="true"
DISABLE_AUTO_TITLE="true"
ENABLE_CORRECTION="false" # this prevents zsh from offering spelling corrections to 'mistyped' commands
COMPLETION_WAITING_DOTS="true"
HIST_STAMPS="mm/dd/yyyy"

# ZSH custom plugins; found in `$ZSH/custom/plugins`
plugins=(colorize) # syntax highlighting for the terminal; aliased as `catc`; SUPER slow with larger files; bundled with oh-my-zsh
# requires pygmentize
# pip install pygments

plugins+=(git) # shows git info for directories containing git repos; bundled with oh-my-zsh

plugins+=(k) # pimped out version of `l`; aliased as `l+` in the navigation section
# install k:
# `git clone git@github.com:supercrabtree/k $ZSH/custom/plugins/k`
# or
# `git clone https://github.com/supercrabtree/k $ZSH/custom/plugins/k`

# To get rid of "'numfmt' or 'gnumfmt' command not found..." error
# brew install coreutils # Done in install/env_setup.sh

plugins+=(z) # frecency based navigation; bundled with oh-my-zsh

plugins+=(zsh-syntax-highlighting) # syntax highlighting for shell scripting
# install zsh-syntax-highlighting:
# `git clone git@github.com:zsh-users/zsh-syntax-highlighting.git $ZSH/custom/plugins/zsh-syntax-highlighting`
# or
# `git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH/custom/plugins/zsh-syntax-highlighting`

##########
#  INIT  #
##########
# ZSH
ZSH_DISABLE_COMPFIX=1 # This prevents the "Insecure completion-dependent directories detected" warning on startup
source $ZSH/oh-my-zsh.sh
source $DOTFILES/custom_zsh_tabs.sh # TODO: this should probably go into $ZSH/custom/plugins
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# Definitions
source $DOTFILES/.colors
export LANG=en_US.UTF-8

# Init language version managers
# Node
export NVM_DIR="$HOME/.nvm"
export NVM_BREW_PREFIX=$(brew --prefix nvm)
[ -s "$NVM_BREW_PREFIX/nvm.sh" ] && . "$NVM_BREW_PREFIX/nvm.sh"  # This loads nvm
[ -s "$NVM_BREW_PREFIX/etc/bash_completion.d/nvm" ] && . "$NVM_BREW_PREFIX/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

## Ruby
if [[ `which rbenv` != *"not found" ]]; then
  eval "$(rbenv init - zsh)"
fi
## Python
if [[ `which pyenv` != *"not found" ]]; then
  eval "$(pyenv init - zsh)"
fi
# Source .zshenv which adds pyenv/rbenv bin dirs to PATH
source $DOTFILES/.zshenv

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
tabs -2

# Functions
# source $DOTFILES/.git_completion
source $DOTFILES/.git_functions
source $DOTFILES/.functions

# Scripts
export PATH="$DOTFILES/scripts:$PATH"
(for file in $(ls -A "$DOTFILES/scripts"); do
  chmod +x "$DOTFILES/scripts/$file"
done &&
  echo 'Sourced scripts/* and appended dir to PATH') ||
  echo 'Something happened :/ ^^^'

# Aliases
source $DOTFILES/.aliases

# CLEAN UP PATH
# clean_path && echo "PATH cleaned of dups"

# Set custom default applications with `duti`
duti $DOTFILES/.duti && echo 'Set custom default applications'

# Symlink global .gitignore
if [ -e ~/.gitignore ]; then
  if [ -L ~/.gitignore ] && [ $(symsrc ~/.gitignore) != "$DOTFILES/.gitignore_global" ]; then
    mv ~/.gitignore ~/.gitignore_bkp &>/dev/null && echo "~/.gitignore already exists; renaming to ~/.gitignore_bkp"
  fi
fi
ln -sf $DOTFILES/.gitignore_global ~/.gitignore && echo "~/.gitignore symlinked to $DOTFILES/.gitignore_global"

echo 'Sourced .zshrc'
