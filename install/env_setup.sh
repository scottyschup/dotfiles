#! /bin/sh

#############################
# Miscellaneous pre-install #
#############################
# To be able to run this script you must first:
## Install Xcode through App Store and launch it once to accept agreement. Then:
sudo xcode-select -s /Applications/Xcode.app/Contents/Developer

############
# Homebrew #
############
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

##############
# Git/Github #
##############
## Setup new SSH key with Github
sshkeygen # save to ~/.ssh/id_rsa
chmod 400 ~/.ssh/id_rsa.pub # https://stackoverflow.com/a/37779390/3251463
cat ~/.ssh/id_rsa.pub | pbcopy
open https://github.com/settings/keys
echo 'Click "New SSH key" button and paste `id_rsa.pub` contents'
echo "Press [y] when done, or press any key to continue without creating new SSH key"
echo "Note some git clone commands will not work if you do not complete this step"
read -qs hasSSHkey
brew install git # system git would be fine for this, but might as well just do it now
git config --global user.name "Scott Schupbach"
git config --global user.email "scott.schupbach@amount.com"

############
# Dotfiles #
############
git clone git@github.com:scottyschup/dotfiles.git
mv dotfiles ~/.dotfiles
export DOTFILES=~/.dotfiles

###################
# MAC OSX changes #
###################
## Set dock animation speed
defaults write com.apple.dock autohide-time-modifier -float 1.0
## Change delay between dock-show trigger and dock-show event
defaults write com.apple.Dock autohide-delay -float 0.5
## show hidden files everywhere
defaults write -g AppleShowAllFiles TRUE
## Keep obnoxious "Try Safari" popup from popping up all the time (requires logout/login?)
defaults write com.apple.coreservices.uiagent CSUIHasSafariBeenLaunched -bool YES
defaults write com.apple.coreservices.uiagent CSUIRecommendSafariNextNotificationDate -date 2050-01-01T00:00:00Z
defaults write com.apple.coreservices.uiagent CSUILastOSVersionWhereSafariRecommendationWasMade -float 10.99
## Prevent power button from sleeping laptop immediately (still works after 2 seconds or so, I think)
defaults write com.apple.loginwindow PowerButtonSleepsSystem -bool no
## Turn off 2-finger swipe navigation in Chrome
# defaults write com.google.Chrome.plist AppleEnableSwipeNavigateWithScrolls -bool FALSE # Doesn't work in Mojave
defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool FALSE
## restart Dock
killall Dock
## restart Finder
killall Finder

##############
# Tools/apps #
##############
# install iTerm, spectacle, Sublime
brew cask install iterm2 spectacle sublime-text
## font for sublime theme: one dark
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
brew tap caskroom/fonts
brew cask install font-source-code-pro
# Use default personal Sublime settings
cp "$DOTFILES/Sublime overrides/Preferences.sublime-settings ~/Library/Application Support/Sublime Text 3/Packages/User/Preferences.sublime-settings"
# Changes invisibles color to a more muted orange
cp "$DOTFILES/Sublime overrides/predawn.tmTheme ~/Library/Application Support/Sublime Text 3/Packages/Predawn/predawn.tmTheme"

##############
# Ruby/rbenv #
##############
brew install rbenv openssl libyaml libffi # The last 3 per ruby-build's recommended build env wiki https://github.com/rbenv/ruby-build/wiki#suggested-build-environment
if [[ `which ruby` =~ ".rbenv" ]]
then
  gem update --system # Only if `which ruby` points to rbenv ruby, not system ruby
else
  echo "Default Ruby is not an rbenv Ruby: $(which ruby)"
fi
gem install bundler rubocop

##########
# Python #
##########
brew install pyenv
pyenv install 2.7.10 # includes pip
pyenv global 2.7.10
## Use pip to install pygmentize (required for oh-my-zsh colorize plugin)
pip install --upgrade pip
pip install pygments

#########
# iTerm #
#########
## install oh-my-zsh
# If at any point you see the message:
#   "package 'Pygments' is not installed!"
# this is because the colorize plugin (installed in .zshrc) requires it
# See Python section to install via pip
export ZSH=~/.oh-my-zsh
brew install zsh zsh-completions
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
mv ~/.zshrc ~/.zshrc_backup
ln -s $DOTFILES/.zshrc ~/.zshrc # Or change the first `.zshrc` to a different `.zshrc_VARIANT` that sources `$DOTFILES/.zshrc`
brew install coreutils # required by k plugin
git clone git@github.com:supercrabtree/k $ZSH/custom/plugins/k
git clone git@github.com:zsh-users/zsh-syntax-highlighting.git $ZSH/custom/plugins/zsh-syntax-highlighting
## Useful terminal tools
# First, go into the iTerm menu and select "Install Shell Integration"
# This gets you `imgcat`, among other things
brew install mdcat tree
brew install librsvg # Used by `mdcat` to support SVG rendering in iTerm
brew install duti # Allows you to set default document and URL handlers via command line

##############
# JS tooling #
##############
brew install nvm npm yarn
# Add these to .*shrc (unless using dotfiles repo, in which case they're already there)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm

#########
# Redis #
#########
brew install redis
## Setup redis.conf
cp /usr/local/etc/redis.conf.default /usr/local/etc/redis.conf
sudo ln -s /usr/lib/libSystem.B.dylib /usr/local/lib/libgcc_s.10.4.dylib

##########
# Docker #
##########
brew cask install virtualbox
brew install docker docker-machine docker-compose
docker-machine create -d virtualbox dev
eval "$(docker-machine env dev)"

######################
# Amount (fka Avant) #
######################
mkdir "~/amount"
export AMOUNT="~/amount"
cd $AMOUNT

## Get all the repos
git clone git@github.com:avantcredit/avant-basic.git
git clone git@github.com:avantcredit/avant-apply.git
git clone git@github.com:avantcredit/avant-views.git
git clone git@github.com:avantcredit/frontend.git

## Install postgres
brew install postgresql@9.4
brew link --force postgresql@9.4
brew services start postgresql@9.4

## avant-basic
cd "$AMOUNT/avant-basic"
### build the correct ruby
rbenv install ${$(cat .ruby-version)#ruby-} # for rvm: `rvm use ${$(cat .ruby-version)#ruby-}`
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
