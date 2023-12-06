#! /bin/sh

# This gist also has some interesting things in it: https://gist.github.com/obatiuk/7be332c88bf6ead4bde7e48329e55f0f

############
# Homebrew #
############
# ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" # old way
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)" # new way; this will also prompt for XCode if needed

##############
# Git/Github #
##############
## Setup new SSH key with Github
ssh-keygen # save to ~/.ssh/id_rsa
chmod 400 ~/.ssh/id_rsa.pub # https://stackoverflow.com/a/37779390/3251463
cat ~/.ssh/id_rsa.pub | pbcopy
open https://github.com/settings/keys
echo 'Click "New SSH key" button and paste `id_rsa.pub` contents'
echo "Press [y] when done, or press any key to continue without creating new SSH key"
echo "Note some git clone commands will not work if you do not complete this step"
read -qs hasSSHkey
brew install git # system git would be fine for this, but might as well just do it now
git config --global user.name "Shannon Schupbach"
git config --global user.email "ssschupbach@gmail.com"
git config --global core.excludesfile "~/.gitignore" # assuming you've symlinked

############
# Dotfiles #
############
git clone git@github.com:scottyschup/dotfiles.git
mv dotfiles ~/.dotfiles
export DOTFILES=~/.dotfiles
ln -s $DOTFILES/.vimrc ~/.vimrc

###################
# MAC OSX changes #
###################

## Set dock animation speed
defaults write com.apple.dock autohide-time-modifier -float 1.0

## Change delay between dock-show trigger and dock-show event
defaults write com.apple.Dock autohide-delay -float 0.5

## Show all filename extensions in Finder
defaults write -g AppleShowAllExtensions -bool true

## Show hidden files everywhere
defaults write -g AppleShowAllFiles TRUE

## Show Library folders
sudo chflags nohidden /Library/ ~/Library/

## Keep obnoxious "Try Safari" popup from popping up all the time (requires logout/login?)
defaults write com.apple.coreservices.uiagent CSUIHasSafariBeenLaunched -bool YES
defaults write com.apple.coreservices.uiagent CSUIRecommendSafariNextNotificationDate -date 2100-01-01T00:00:00Z
defaults write com.apple.coreservices.uiagent CSUILastOSVersionWhereSafariRecommendationWasMade -float 10.99

## Prevent power button from sleeping laptop immediately (still works after 2 seconds or so, I think)
defaults write com.apple.loginwindow PowerButtonSleepsSystem -bool no

## Turn off 2-finger swipe navigation in Chrome
# defaults write com.google.Chrome.plist AppleEnableSwipeNavigateWithScrolls -bool FALSE # Doesn't work in Mojave
defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool FALSE

## Change default location for screenshots
mkdir ~/Pictures/screenshots
defaults write com.apple.screencapture location ~/Pictures/screenshots

## Get rid of obnoxious OS beep when using certain key combos (cmd+ctrl+DOWN, for example)
# Taken from: https://github.com/adobe/brackets/issues/2419#issuecomment-344351507 (def works on El Capitan -> Catalina)
# See also https://gist.github.com/trusktr/1e5e516df4e8032cbc3d for larger list of keybindings
# and http://xahlee.info/kbd/osx_keybinding_action_code.html for keybinding action names
mkdir ~/Library/KeyBindings && echo "{
  \"@^\\\UF701\" = \"noop:\";
  \"@^\\\UF702\" = \"noop:\";
  \"@^\\\UF703\" = \"noop:\";
}
" > ~/Library/KeyBindings/DefaultKeyBinding.dict

## restart Dock and Finder
killall Dock
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
# brew tap heroku/brew && brew install heroku

##########
# Python #
##########
brew install pyenv
pyenv install 2.7.18 # Because I'm old school like that
pyenv install 3.8.5
pyenv global 3.8.5
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
# `librsvg` is used by `mdcat` to support SVG rendering in iTerm
# `duti` allows you to set default document and URL handlers via command line
brew install mdcat tree librsvg duti

##############
# JS tooling #
##############
brew install nvm npm yarn
# Add these to .*shrc (unless using dotfiles repo, in which case they're already there)
export NVM_DIR="$HOME/.nvm"
[ -s "$(brew --prefix nvm)/nvm.sh" ] && . "$(brew --prefix nvm)/nvm.sh" # This loads nvm

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
