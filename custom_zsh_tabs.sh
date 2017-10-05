#! /bin/bash

function precmd {
  setTitles $PWD
}

function setMainTitle {
  echo -ne "\033]2;$(titleOrPWD $1)\007"
}

function setTabTitle {
  echo -ne "\033]1;$(shortTitle $1)\007"
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

function shortTitle {
  COUNTER=0
  TMP_TITLE=`titleOrPWD $1`
  for word in $(echo $TMP_TITLE | tr "/" " "); do
    let "COUNTER+=1"
    APU_WORD=$PU_WORD
    PU_WORD=$U_WORD
    U_WORD=$word
  done
  #
  if [ $COUNTER -lt '3' ]; then
    TITLE=$TMP_TITLE
  elif [ $APU_WORD = $USER ]; then
    TITLE="~/$PU_WORD/$U_WORD"
  elif [ $PU_WORD = $USER ]; then
    TITLE="~/$U_WORD"
  elif [ $U_WORD = $USER ]; then
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

echo 'custom_zsh_tabs.sh sourced'
