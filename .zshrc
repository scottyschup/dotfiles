#!/usr/bin/zsh -w

echo "$GRN""Sourced$NONE .zshenv" # To remind me that .zshenv gets sourced before .zshrc

# Ensure Homebrew is in path since it's used throughout this file
export PATH=/opt/homebrew/bin:/opt/homebrew/sbin:$PATH

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

# For compilers to find openssl
export CPPFLAGS="-I$(brew --prefix)/include"
export LDFLAGS="-L$(brew --prefix)/lib"

# For pkg-config to find openssl@1.1
export PKG_CONFIG_PATH="/opt/homebrew/opt/openssl@1.1/lib/pkgconfig"

# ZSH theme/configuration
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
export LANG=en_US.UTF-8

# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/google-cloud-sdk/path.zsh.inc"; fi
# The next line enables shell command completion for gcloud.
if [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/google-cloud-sdk/completion.zsh.inc"; fi

# Init language version managers
## Load nvm from Homebrew unless asdf is installed
if [[ `which asdf` = *"not found" ]]; then
  export NVM_DIR="$HOME/.nvm"
  [ -s "$(brew --prefix nvm)/nvm.sh" ] && . "$(brew --prefix nvm)/nvm.sh"

  if [[ `which nvm` != *"not found" ]]; then
    # Hook into `cd` to automatically switch Node version if `.nvmrc` present
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
    echo 'nvm initialized' && node -v && which node
  fi # end of NVM auto-switch setup

  ## Optional rbenv/chruby setup
  if [[ `which rbenv` != *"not found" ]]; then
    eval "$(rbenv init - zsh)"
    export PATH="$HOME/.rbenv/bin:$PATH"
    echo 'rbenv initialized' && ruby -v && which ruby
  fi

  if [[ `which chruby` != *"not found" ]]; then
    source /opt/homebrew/opt/chruby/share/chruby/chruby.sh
    source /opt/homebrew/share/chruby/auto.sh # automatically switches to the version specified in a .ruby-version file
    chruby ruby-3.2.2 # Global Ruby--default Ruby used unless a .ruby-version file exists
    echo "chruby$GRN initialized$NONE" && ruby -v && which ruby
  fi

  ## Optional pyenv setup
  if [[ `which pyenv` != *"not found" ]]; then
    eval "$(pyenv init -)"
    export PATH="$HOME/.pyenv/bin:$PATH"
    echo "pyenv$GRN initialized$NONE" && python --version && which python
  fi

fi # end of if !asdf block

# Aliases
source $DOTFILES/.aliases

# Scripts
export PATH="$DOTFILES/scripts:$PATH"
(for file in $(ls -A "$DOTFILES/scripts"); do
  chmod +x "$DOTFILES/scripts/$file"
done &&
  echo "scripts/* have been$GRN chmoded and added to PATH$NONE") ||
  echo "$RED""Something happened$NONE with the scripts loop :/ ^^^"

# Aliases that depend on scripts
source $DOTFILES/.aliases-post-scripts

# Set custom default applications with `duti`
(duti $DOTFILES/.duti && echo "$GRN""Set$NONE custom default applications") || echo "$RED""Failed to set$NONE custom default applications"

# Symlink global .gitignore
if [ -e ~/.gitignore ]; then
  if [ -L ~/.gitignore ] && [ $(symsrc ~/.gitignore) != "$DOTFILES/.gitignore_global" ]; then
    mv ~/.gitignore ~/.gitignore_bkp &>/dev/null && echo "~/.gitignore$YLW already exists$NONE; renaming to ~/.gitignore_bkp"
  fi
fi
ln -sf $DOTFILES/.gitignore_global ~/.gitignore && echo "~/.gitignore$GRN symlinked$NONE to $DOTFILES/.gitignore_global"

####################################################################
# Remove duplicates from PATH in the event of re-sourcing dotfiles #
####################################################################
# The correct zsh way: https://man.archlinux.org/man/zshall.1.en#U~6
typeset -U PATH path
echo "PATH$GRN uniqified$NONE!"

# asdf (must be initialized after PATH is uniquified)
# Note: in bash, change `!= *"not found"` to `!= ""`
if [[ `which asdf` != *"not found" && `which node` != *".asdf/shims"* ]]; then
  source $(brew --prefix asdf)/libexec/asdf.sh
  echo "asdf$GRN initialized$NONE" && asdf current
fi

echo "$GRN""Sourced$NONE .zshrc"
