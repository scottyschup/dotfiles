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
## show hidden files everywhere
defaults write -g AppleShowAllFiles TRUE
## Set dock animation speed
defaults write com.apple.dock autohide-time-modifier -float 1.0
## Add longer delay between dock show trigger and dock show event
defaults write com.apple.Dock autohide-delay -float 2.0
## Keep obnoxious "Try Safari" popup from popping up all the time (requires logout/login?)
defaults write com.apple.coreservices.uiagent CSUIHasSafariBeenLaunched -bool YES
defaults write com.apple.coreservices.uiagent CSUIRecommendSafariNextNotificationDate -date 2050-01-01T00:00:00Z
defaults write com.apple.coreservices.uiagent CSUILastOSVersionWhereSafariRecommendationWasMade -float 10.99
## Prevent power button from sleeping laptop immediately (still works after 2 seconds or so, I think)
defaults write com.apple.loginwindow PowerButtonSleepsSystem -bool no

## restart Dock and Finder
killall Dock Finder

# Homebrew
# install iTerm, spectacle, Sublime
brew cask install iterm2
brew cask install spectacle
brew cask install sublime-text
## Packages to install:
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
## also need to manually install theme through Subl's pkg installer
brew tap caskroom/fonts
brew cask install font-source-code-pro
cp $DOTFILES/Preferences.sublime-settings ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User/Preferences.sublime-settings # will overwrite existing user preferences

# install oh-my-zsh
export ZSH=~/.oh-my-zsh
brew install zsh zsh-completions
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
rm ~/.zshrc
ln -s ~/.dotfiles/.zshrc_avant ~/.zshrc # if using dotfiles repo; amend variant name if necessary
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

# Node via nvm
brew install nvm npm
# Add these to .*shrc if not using dotfiles
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm

# Yarn
brew install yarn

# Ruby via rbenv
brew install rbenv
brew install openssl libyaml libffi # per ruby-build's recommended build env wiki https://github.com/rbenv/ruby-build/wiki#suggested-build-environment
rbenv install 2.3.4
rbenv global 2.3.4
gem update --system # only if which ruby points to brew ruby, not system ruby; otherwise re-source dotfiles
gem install bundler rubocop

# Redis
brew install redis

# Docker
brew cask install virtualbox
brew install docker docker-machine docker-compose
docker-machine create -d virtualbox dev
eval "$(docker-machine env dev)"

# Avant
mkdir ~/avant
export AVANT=~/avant
cd $AVANT

## avant-basic
### install avant-basic necessities
brew install qt55
### setup redis.conf
cp /usr/local/etc/redis.conf.default /usr/local/etc/redis.conf
### link qt55
brew link --force qt55

### install and start postgres
brew install postgresql@9.4
brew link postgresql@9.4 --force
brew services start postgresql@9.4

### get the repo
git clone git@github.com:avantcredit/avant-basic.git
cd avant-basic

### build the correct ruby
rbenv install ${$(cat .ruby-version)#ruby-}

### gems
gem update --system
gem install bundler
bundle install

### database
cp config/database.yml.sample.yaml config/database.yml
/bin/local_prep

### install and start mailcatcher
gem install mailcatcher
mailcatcher # Daemonized by default; add -f flag to run in foreground
