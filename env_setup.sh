# Show hidden files in Finder
defaults write -g AppleShowAllFiles TRUE

# get dotfiles if not already done
cd
git clone git@github.com:scottyschup/dotfiles.git
mv dotfiles .dotfiles
rm ~/.zshrc
ln -s ~/.zshrc ~/.dotfiles/.zshrc

# install homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# install oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"


# install iTerm Sublime Heroku Git npm
brew cask install iterm2
brew cask install sublime-text
brew cask install heroku
brew cask install git
brew cask install npm

# install nvm
brew install nvm
# Add these to .zshrc if not using dotfiles yet
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm

# install rbenv
