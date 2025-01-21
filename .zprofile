# eval "$(/opt/homebrew/bin/brew shellenv)"

# # chruby
# if [[ `which chruby` != *"not found" ]]; then
#   source /opt/homebrew/opt/chruby/share/chruby/chruby.sh
#   source /opt/homebrew/opt/chruby/share/chruby/auto.sh
# fi

# # asdf (must be initialized after PATH is uniquified)
# # Note: in bash, change `!= *"not found"` to `!= ""`
# if [[ `which asdf` != *"not found" ]]; then
#   source $(brew --prefix asdf)/libexec/asdf.sh
. /opt/homebrew/opt/asdf/libexec/asdf.sh
# fi

# echo 'Sourced .zprofile'
