#! /bin/sh

# MAC OSX changes
## show hidden files everywhere
defaults write -g AppleShowAllFiles TRUE
## Set dock animation speed
defaults write com.apple.dock autohide-time-modifier -float 1.0
## Add longer delay between dock show trigger and dock show event
defaults write com.apple.Dock autohide-delay -float 2.0
## restart Dock and Finder
killall Dock Finder

# Dotfiles
## may need to setup new SSH key with Github first
sshkeygen
cat ~/.ssh/id_rsa.pub | pbcopy
open https://github.com/settings/keys
## clone dotfiles repo
cd ~
brew install git # system git would be fine for this, but might as well just do it now
git clone git@github.com:scottyschup/dotfiles.git
mv dotfiles .dotfiles
export DOTFILES=~/.dotfiles

# Homebrew
## install
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# install iTerm, spectacle, Sublime
brew cask install iterm2
brew cask install spectacle
brew cask install sublime-text
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

# install pyenv
brew install pyenv
pyenv install 2.7.10 # includes pip
pyenv global 2.7.10
## use pip to install pygmentize
pip install --upgrade pip
pip install pygments
source ~/.zshrc

# install nvm
brew install nvm
# Add these to .zshrc if not using dotfiles yet
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm

# install rbenv
brew install rbenv
brew install openssl libyaml libffi # per ruby-build's recommended build env wiki https://github.com/rbenv/ruby-build/wiki#suggested-build-environment
rbenv install 2.3.4
rbenv global 2.3.4
gem update --system # only if which ruby points to brew ruby, not system ruby; otherwise re-source dotfiles
gem install bundler

# install other commonly used components
brew install npm redis

# Avant
mkdir ~/avant
export AVANT=~/avant
cd $AVANT

## install avant-basic necessities
brew install rabbitmq heroku-toolbelt qt55
## setup redis.conf
cp /usr/local/etc/redis.conf.default /usr/local/etc/redis.conf
## start rabbitmq
brew services start rabbitmq
## link qt55
brew link --force qt55

# install and start postgres
brew install postgresql@9.4
brew link postgresql@9.4 --force
brew services start postgresql@9.4

# TODO: pg setup

## avant-basic
### Don't forget to install Xcode through App Store and launch to accept agreement. Also see note after bundle install step below about other potential problems
git clone git@github.com:avantcredit/avant-basic.git
cd avant-basic
rbenv install 2.2.4
gem install bundler -v 1.14.6
# Run the following line if bundle install fails at Capybara with `Project ERROR: Xcode not set up properly. You may need to confirm the license agreement by running /usr/bin/xcodebuild` and running xcodebuild says `xcode-select: error: tool 'xcodebuild' requires Xcode, but active developer directory '/Library/Developer/CommandLineTools' is a command line tools instance`
sudo xcode-select -s /Applications/Xcode.app/Contents/Developer

