
# Show hidden files in Finder
defaults write -g AppleShowAllFiles TRUE

# get dotfiles if not already done
# may need to setup new SSH key with Github first
sshkeygen
cat ~/.ssh/id_rsa.pub | pbcopy
open https://github.com/settings/keys

cd ~
git clone git@github.com:scottyschup/dotfiles.git
mv dotfiles .dotfiles

# install homebrew
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# install iTerm, spectacle, Sublime
brew cask install iterm2
brew cask install spectacle
brew cask install sublime-text

# install oh-my-zsh
export ZSH=~/.oh-my-zsh
brew install zsh zsh-completions
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
rm ~/.zshrc
ln -s ~/.dotfiles/.zshrc_avant ~/.zshrc # if using dotfiles repo; amend variant name if necessary
brew install coreutils # needed by k
git clone git@github.com:supercrabtree/k $ZSH/custom/plugins/k
git clone git@github.com:zsh-users/zsh-syntax-highlighting.git $ZSH/custom/plugins/zsh-syntax-highlighting
# colorize plugin requires pygmentize (through pip)
# install pyenv to get pip
brew install pyenv
pyenv install 2.7.10
pyenv global 2.7.10
pip install --upgrade pip
pip install pygments
source ~/.zshrc

# font for theme - one dark (Sublime)
# also need to manually install theme through Subl's pkg installer
brew tap caskroom/fonts
brew cask install font-source-code-pro


# install avant-basic necessities
brew install git npm redis rabbitmq heroku-toolbelt qt55
# setup redis.conf
cp /usr/local/etc/redis.conf.default /usr/local/etc/redis.conf
# start rabbitmq
brew services start rabbitmq
# link qt55
brew link --force qt55

# install and start postgres
brew install postgresql@9.4
brew link postgresql@9.4 --force
brew services start postgresql@9.4

# TODO: pg setup

# install nvm
brew install nvm
# Add these to .zshrc if not using dotfiles yet
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm

# install rbenv
brew install rbenv
