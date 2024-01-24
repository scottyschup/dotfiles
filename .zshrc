#!/usr/bin/zsh -w

source `brew --prefix`/etc/profile.d/z.sh &>/dev/null
export LANG=en_US.UTF-8
export PATH=/usr/local/git/bin:/opt/local/bin:/opt/local/sbin:$PATH:/mybin
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

ORIGINAL_PROMPT=$PROMPT
TIMESTAMP_PROMPT='%{$fg[yellow]%}[%D{%f/%m/%y} %D{%L:%M:%S}] '$PROMPT

function toggle_prompt {
  if [ "$PROMPT" = "$ORIGINAL_PROMPT" ]
  then
    PROMPT="$TIMESTAMP_PROMPT"
  else
    PROMPT="$ORIGINAL_PROMPT"
  fi
}

# These openssl hacks were needed in earlier OS versions (v10, v11) but not anymore (v14)
# For compilers to find openssl@1.1
export LDFLAGS="-L/opt/homebrew/opt/openssl@1.1/lib"
export CPPFLAGS="-I/opt/homebrew/opt/openssl@1.1/include"
# For pkg-config to find openssl@1.1
export PKG_CONFIG_PATH="/opt/homebrew/opt/openssl@1.1/lib/pkgconfig"

# General
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

plugins+=(rails)
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

# Activate zsh-completions
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

  autoload -Uz compinit
  compinit
fi

# Definitions
source $DOTFILES/.colors
export LANG=en_US.UTF-8

# Init language version managers
## Node/nvm
export NVM_DIR="$HOME/.nvm"
export NVM_BREW_PREFIX=$(brew --prefix nvm)
[ -s "$NVM_BREW_PREFIX/nvm.sh" ] && . "$NVM_BREW_PREFIX/nvm.sh"  # This loads nvm from Homebrew
# [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm from manual installation
[ -s "$NVM_BREW_PREFIX/etc/bash_completion.d/nvm" ] && . "$NVM_BREW_PREFIX/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/ssschupbach/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/ssschupbach/google-cloud-sdk/path.zsh.inc'; fi
# The next line enables shell command completion for gcloud.
if [ -f '/Users/ssschupbach/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/ssschupbach/google-cloud-sdk/completion.zsh.inc'; fi

# Hook into `cd` to automatically swtich Node version if `.nvmrc` present
# Must be after nvm initialization
autoload -U add-zsh-hook
load-nvmrc() {
  local node_version="$(nvm version)"
  local nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    echo "Reverting to nvm default version"
    nvm use default
  fi
}
add-zsh-hook chpwd load-nvmrc
load-nvmrc

## Ruby
# Using chruby now :/
# if [[ `which rbenv` != *"not found" ]]; then
#   eval "$(rbenv init - zsh)"
# fi
source $HOMEBREW_PREFIX/opt/chruby/share/chruby/chruby.sh
source $HOMEBREW_PREFIX/share/chruby/auto.sh # automatically switches to the version specified in a .ruby_version file
chruby ruby-3.2.2 # Global Ruby--default Ruby used unless a .ruby_version file exists

## Python
if [[ `which pyenv` != *"not found" ]]; then
  eval "$(pyenv init --path)"
  # eval "$(pyenv init - zsh)"
fi

## Add rbenv/pyenv bin to PATH for scripting. Make sure this is the last PATH variable change.
# export PATH="$(npm bin):$PATH" # npm bin no longer works as of NPM v9; use npx
export PATH="$HOME/.pyenv/bin:$PATH"
# Using chruby now :/
# export PATH="$HOME/.rbenv/bin:$PATH"

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

# Custom functions
source $DOTFILES/.git_functions
source $DOTFILES/.functions

# Aliases
source $DOTFILES/.aliases

# Scripts
export PATH="$DOTFILES/scripts:$PATH"
(for file in $(ls -A "$DOTFILES/scripts"); do
  chmod +x "$DOTFILES/scripts/$file"
done &&
  echo 'scripts/* have been chmoded and added to PATH') ||
  echo 'Something happened with the scripts loop :/ ^^^'

# Aliases that depend on scripts
source $DOTFILES/.aliases-post-scripts

# Set custom default applications with `duti`
duti $DOTFILES/.duti && echo 'Set custom default applications'

# Symlink global .gitignore
if [ -e ~/.gitignore ]; then
  if [ -L ~/.gitignore ] && [ $(symsrc ~/.gitignore) != "$DOTFILES/.gitignore_global" ]; then
    mv ~/.gitignore ~/.gitignore_bkp &>/dev/null && echo "~/.gitignore already exists; renaming to ~/.gitignore_bkp"
  fi
fi
ln -sf $DOTFILES/.gitignore_global ~/.gitignore && echo "~/.gitignore symlinked to $DOTFILES/.gitignore_global"

####################################################################
# Remove duplicates from PATH in the event of re-sourcing dotfiles #
####################################################################
# Repeatedly re-sourcing dotfiles causes the PATH to grow making session startup
# slower each time, so duplicates are being removed here.
export PATH=$(ruby -e 'puts `echo $PATH`.split(":").uniq[0..-1].join(":")')
echo "PATH uniqified!"

echo 'Sourced .zshrc'
