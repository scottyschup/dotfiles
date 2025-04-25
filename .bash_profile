# asdf (must be initialized after all PATH changes)
# Note: in zsh, change `!= ""` to `!= *"not found"`
if [[ `which asdf` != "" ]]; then
  source $(brew --prefix asdf)/libexec/asdf.sh
  echo 'asdf initialized' && asdf current
fi

echo 'Sourced .bash_profile'

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/sscottschupbach/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)
