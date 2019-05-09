#! /bin/sh

# # To be able to run this script you must first:
# # Miscellaneous pre-install
# ## Install Xcode through App Store and launch it once to accept agreement
# sudo xcode-select -s /Applications/Xcode.app/Contents/Developer
# # Homebrew
# ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# # Git/Github setup
# ## Probably need to setup new SSH key with Github
# sshkeygen # save to ~/.ssh/id_rsa
# chmod 400 ~/.ssh/id_rsa.pub # https://stackoverflow.com/a/37779390/3251463
# cat ~/.ssh/id_rsa.pub | pbcopy
# open https://github.com/settings/keys # Create new ssh key and paste id_rsa.pub contents
# brew install git # system git would be fine for this, but might as well just do it now
# git config --global user.name "Scott Schupbach"
# git config --global user.email "scott.schupbach@amount.com"

# # Dotfiles
# git clone git@github.com:scottyschup/dotfiles.git
# mv dotfiles ~/.dotfiles
# export DOTFILES=~/.dotfiles

# MAC OSX changes
## Set dock animation speed
defaults write com.apple.dock autohide-time-modifier -float 1.0
## Change delay between dock-show trigger and dock-show event
defaults write com.apple.Dock autohide-delay -float 0.5
## restart Dock
killall Dock

## show hidden files everywhere
defaults write -g AppleShowAllFiles TRUE
## Keep obnoxious "Try Safari" popup from popping up all the time (requires logout/login?)
defaults write com.apple.coreservices.uiagent CSUIHasSafariBeenLaunched -bool YES
defaults write com.apple.coreservices.uiagent CSUIRecommendSafariNextNotificationDate -date 2050-01-01T00:00:00Z
defaults write com.apple.coreservices.uiagent CSUILastOSVersionWhereSafariRecommendationWasMade -float 10.99
## Prevent power button from sleeping laptop immediately (still works after 2 seconds or so, I think)
defaults write com.apple.loginwindow PowerButtonSleepsSystem -bool no

## restart Finder
killall Finder

# Homebrew
# install iTerm, spectacle, Sublime
brew cask install iterm2
brew cask install spectacle
brew cask install sublime-text
## Packages to install manually:
# * Predawn
# * Material Theme
# * Material Theme - White Panels
# * A File Icon
# * Babel
# * Babel Snippets
# * Better CoffeeScript
# * Dotfiles Syntax Highlighting
# * Git
# * Git Gutter
# * Haml
# * Jade
# * Package Resource Viewer
# * Sass
# * SideBarEnhancements
# * Stylus
# * SublimeERB
# * SublimeLinter
# * SyntaxHighlightTools
# * TypeScript
# * VIM Navigation
## font for sublime theme - one dark
brew tap caskroom/fonts
brew cask install font-source-code-pro
# Use default personal Sublime settings
cp $DOTFILES/Sublime\ overrides/Preferences.sublime-settings ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User/Preferences.sublime-settings
# Changes invisibles color to a more muted orange
cp $DOTFILES/Sublime\ overrides/predawn.tmTheme ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/Predawn/predawn.tmTheme

# install oh-my-zsh
export ZSH=~/.oh-my-zsh
brew install zsh zsh-completions
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
mv ~/.zshrc ~/.zshrc_backup
ln -s $DOTFILES/.zshrc ~/.zshrc # Or change the first `.zshrc` to a different `.zshrc_VARIANT` that sources `$DOTFILES/.zshrc`
brew install coreutils # needed by k
git clone git@github.com:supercrabtree/k $ZSH/custom/plugins/k
git clone git@github.com:zsh-users/zsh-syntax-highlighting.git $ZSH/custom/plugins/zsh-syntax-highlighting
## colorize plugin requires pygmentize (pygments); see next steps

# Python via pyenv
brew install pyenv
pyenv install 2.7.10 # includes pip
pyenv global 2.7.10
## use pip to install pygmentize
pip install --upgrade pip
pip install pygments
source ~/.zshrc

# JS tooling
brew install nvm npm yarn
# Add these to .*shrc (unless using dotfiles repo, in which case they're already there)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm


# rbenv
brew install rbenv
brew install openssl libyaml libffi # per ruby-build's recommended build env wiki https://github.com/rbenv/ruby-build/wiki#suggested-build-environment
# gem update --system # if `which ruby` points to brew ruby, not system ruby
gem install bundler rubocop

# Redis
brew install redis
## Setup redis.conf
cp /usr/local/etc/redis.conf.default /usr/local/etc/redis.conf
sudo ln -s /usr/lib/libSystem.B.dylib /usr/local/lib/libgcc_s.10.4.dylib

# Docker
brew cask install virtualbox
brew install docker docker-machine docker-compose
docker-machine create -d virtualbox dev
eval "$(docker-machine env dev)"

# Avant/Amount
mkdir ~/avant
export AVANT=~/avant
cd $AMOUNT

## avant-basic
### install postgres
brew install postgresql@9.4
brew link --force postgresql@9.4
brew services start postgresql@9.4

### get the repo(s)
git clone git@github.com:avantcredit/avant-basic.git
git clone git@github.com:avantcredit/avant-apply.git
git clone git@github.com:avantcredit/avant-views.git
git clone git@github.com:avantcredit/frontend.git
cd avant-basic

### build the correct ruby
rbenv install ${$(cat .ruby-version)#ruby-}
# rvm use ${$(cat .ruby-version)#ruby-}

### gems
gem update --system
gem install bundler
bundle install

### database
cp config/database.yml.sample.yaml config/database.yml
bin/prep_local

### install and start mailcatcher
gem install mailcatcher
mailcatcher # Daemonized by default; add -f flag to run in foreground
