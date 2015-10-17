# Path to your oh-my-zsh installation.
export ZSH=/Users/sschupbach/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="robbyrussell"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git atom ruby colorize rails zsh-syntax-highlighting)

# User configuration

export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"
export SPARK_HOME=/usr/local/Cellar/apache-spark/1.4.1-custom
export PYTHONPATH=$SPARK_HOME/libexec/python:$SPARK_HOME/libexec/python/build:$PYTHONPATH
export PYSPARK_HOME=/usr/local/Cellar/apache-spark/1.4.1-custom/python
export ASPERA_ANALYTICS_HOME=~/Documents/gitlab/analytics/a0/data
# export MANPATH="/usr/local/man:$MANPATH"
source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.

# general common functions
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
export PATH="/usr/local/sbin:$PATH"

alias az='atom ~/.zshrc'
alias av='atom ~/.vimrc'
alias aomz="atom ~/.oh-my-zsh"

alias vz='vim ~/.zshrc'
alias vv='vim ~/.vimrc'

alias sz='source ~/.zshrc'

alias chrome="open -a 'Google Chrome'"

# networking
function pingGoogle {
  if [ ! -n "$1" ]; then
    ping -c 5 google.com
  else
    ping -c $1 google.com
  fi
}

# navigation
alias ll='ls -lAhL'
alias lt='ls -AhL *'
alias llt='ls -lAhL *'
alias up='cd ..'
alias upp='cd ../..'
alias upl='cd ../ && ls -lah'

function cdl { 
  cd $1 && ls -lah
}

function cda {
  cd $1 && atom .
}

function whcd {
  cd `which $1 | xargs dirname`
}

function whcdl {
  cd `which $1 | xargs dirname` && ls -lah
}

function mkcd {
  if [ ! -n "$1" ]; then
    echo "Enter a directory name"
  elif [ -d $1 ]; then
    echo "\`$1' already exists"
  else
    mkdir $1 && cd $1
  fi
}

function aahome {
  cd ~/Documents/gitlab/analytics/a$1
  setTabTitle "analytics/a$1"
  setMainTitle
}

function setTitles {
  if [ $2 ]; then
    TITLE2=$2
  else
    TITLE2=$1
  fi
  setMainTitle $TITLE2
  setTabTitle $1
}

function setTabTitle {
  echo -ne "\033]1;$(shortTitle $1)\007"
}

function setMainTitle {
  echo -ne "\033]2;$(titleOrPWD $1)\007"
}

function shortTitle {
  COUNTER=0
  TMP_TITLE=`titleOrPWD $1`
  for word in $(echo $TMP_TITLE | tr "/" " "); do
    let "COUNTER+=1"
    APU_WORD=$PU_WORD
    PU_WORD=$U_WORD
    U_WORD=$word
  done

  if [ $COUNTER -lt '3' ]; then
    TITLE=$TMP_TITLE
  elif [ $APU_WORD = 'sschupbach' ]; then
    TITLE="~/$PU_WORD/$U_WORD"
  elif [ $PU_WORD = 'sschupbach' ]; then
    TITLE="~/$U_WORD"
  elif [ $U_WORD = 'sschupbach' ]; then
    TITLE='~'
  else
    TITLE=".../$PU_WORD/$U_WORD"
  fi

  echo "$TITLE"
}

function titleOrPWD {
  if [ $1 ]; then
    TITLE=$1
  else
    TITLE=$PWD
  fi
  echo $TITLE
}

function precmd {
  setTitles $PWD
}

# python server
alias pyss='python -m SimpleHTTPServer'

# analytics local setup
alias ras='cd ~/Documents/gitlab/aspera-analytics/rails && rails server'
alias start-spark='cd /usr/local/Cellar/apache-spark/1.4.1-custom/sbin && ./start-slaves.sh; sleep 1; ./start-master.sh'
alias stop-spark='cd /usr/local/Cellar/apache-spark/1.4.1-custom/sbin && ./stop-slaves.sh; sleep 1; ./stop-master.sh'
alias restart-spark='cd /usr/local/Cellar/apache-spark/1.4.1-custom/sbin && stop-spark; sleep 3; start-spark'
alias start-redis='redis-server'
alias start-api-server='cd ~/Documents/gitlab/analytics/a0/data && ./run.py -d 5 -p --mode object server'
alias switch-to-local-server-file='cd ~/Documents/gitlab/analytics/a0 && cp ./server.yaml.local ./server.yaml'
alias switch-to-remote-server-file='cd ~/Documents/gitlab/analytics/a0 && cp ./server.yaml.remote ./server.yaml'

# git aliases
alias ga='git add'
alias gaa='git add .'
alias gac='git add . && git commit -m'
alias gb='git branch'
alias gba='git branch -a' # list all branches
alias gbd='git branch -D' # delete local branch
alias gbdr='git push origin --delete' # delete remote branch
alias gcb='git checkout -b' # create new branch
alias gc='git commit -m'
alias gco='git checkout'
alias gcm='git checkout master'
alias gd='git diff'
alias gds='git diff --stat'
alias gdns='git diff --numstat'
alias gf='git fetch'
alias ghl='cat .git/refs/heads/master' # full hash
alias ghs='git log --pretty=format:"%h" -n 1 | cat' # short hash
alias gm='git merge'
alias gp='git push'
alias gpl='git pull'
alias gplsu='git pull --set-upstream'
alias gpsu='git push --set-upstream'
alias gs='git status'
alias gviz='git log --oneline --decorate --graph --all'

function glastnhashes {
  git rev-list --max-count=$1 HEAD
}

function gitgoforward {
  git checkout `git rev-list --topo-order HEAD..$1 | tail -1`
}

# bundle
alias be='bundle exec'
alias bi='bundle install'
alias bo='bundle open'
alias bu='bundle update'

# Keypad
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
