# User configuration
export PATH="/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"
export SPARK_HOME=/usr/local/Cellar/apache-spark/1.4.1-custom
export PYTHONPATH=$SPARK_HOME/libexec/python:$SPARK_HOME/libexec/python/build:$PYTHONPATH
export PYSPARK_HOME=/usr/local/Cellar/apache-spark/1.4.1-custom/python
export ASPERA_ANALYTICS_HOME=~/Documents/gitlab/analytics/a0/data
export MANPATH="/usr/local/man:$MANPATH"
source ./oh-my-zsh.sh

ZSH_THEME="robbyrussell"
DISABLE_AUTO_TITLE="true"
COMPLETION_WAITING_DOTS="true"
plugins=(git atom ruby colorize rails zsh-syntax-highlighting z)

# general common functions
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

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
alias ll='k -Ah'
alias lst='ls -AhL *'
alias lt='k -Ah *'
alias up='cd ..'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias upl='cd ../ && k -Ah'

function cdl {
  cd $1 && k -Ah
}

function cda {
  cd $1 && atom .
}

function whcd {
  cd `which $1 | xargs dirname`
}

function whcdl {
  cd `which $1 | xargs dirname` && k -Ah
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
alias switch-to-local-server-file='cd ~/Documents/gitlab/analytics/a0-proto-analytics && cp ./server.yaml.local ./server.yaml'
alias switch-to-remote-server-file='cd ~/Documents/gitlab/analytics/a0-proto-analytics && cp ./server.yaml.remote ./server.yaml'

# git aliases
alias g='git'
alias ga='git add'
alias gaa='git add .'
alias gac='git add . && git commit -m'
alias gb='git branch'
alias gba='git branch -a' # list all branches
alias gbd='git branch -D' # delete local branch
alias gbdr='git push origin --delete' # delete remote branch
alias gcb='git checkout -b' # create new branch
alias gcm='git commit -m'
alias gco='git checkout'
alias gcom='git checkout master'
alias gd='git diff'
alias gds='git diff --stat'
alias gdns='git diff --numstat'
alias gf='git fetch'
alias ghl='cat .git/refs/heads/master' # full hash
alias ghs='git log --pretty=format:"%h" -n 1 | cat' # short hash
alias gm='git merge'
alias gp='git push'
alias gpl='git pull'
alias gplu='git pull -u'
alias gpluo='git pull -u origin'
alias gpu='git push -u'
alias gpuo='git push -u origin'
alias gra='git remote add'
alias grb='git rebase'
alias grbm='git rebase master'
alias grr='git remote remove'
alias grao='git remote add origin'
alias grro='git remote remove origin'
alias grv='git remote --verbose'
alias gs='git status'
alias gst='git stash'
alias gsa='git stash apply'
alias gsai='git stash apply --index'
alias gsb='git stash branch'
alias gsl='git stash list'
alias gsu='git stash show -p | git apply -R' #=> git stash unapply
alias gviz='git log --oneline --decorate --graph --all'

function gacp {
  if [ $1 ]; then
    G_MESSAGE=$1
  else
    return "Enter a commit message"
  fi

  G_BRANCH=$(git rev-parse --symbolic-full-name --abbrev-ref HEAD)
  git add .; git commit -m $G_MESSAGE; git push -u origin $G_BRANCH
}

# grunt
alias gt='grunt'
alias gts='grunt serve'
alias gtt='grunt test'

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

# rails
alias r='rails'

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

source ~/.k.sh
source ~/.z.sh
