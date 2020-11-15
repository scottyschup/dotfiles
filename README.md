# Scott Schupbach's custom `.*rc`s, `.aliases`, `oh-my-zsh` customizations, etc.
This is just for me to make my terminal workflow more consistent between work and personal laptops, but if you've stumbled upon this and find any of it to be of use, by all means help yourself!

### Setup
- Clone the `dotfiles` repo in your home directory, or wherever
  ```sh
  git clone git@github.com:scottyschup/dotfiles.git $HOME/.dotfiles
  ```
  - If not home, then change the `$DOTFILES` var in your `.zshrc_<VARIANT>`

- create a `.zshrc` symlink to the `.zshrc_<VARIANT>` of your choosing in your home directory. (Change `<VARIANT>` to home, work, company/laptop name, etc.)
  ```sh
  export DOTFILES=$HOME/.dotfiles # or wherever your copy lives
  ln -s $DOTFILES/.zshrc_<VARIANT> ~/.zshrc
  ln -s $DOTFILES/.zshenv ~/.zshenv
  ```

- If using Rails, create a `.railsrc` symlink as well:
  ```sh
  ln -s $DOTFILES/.railsrc ~/.railsrc
  ```

- If using vim, create a `.vimrc` symlink as well:
  ```sh
  ln -s $DOTFILES/.vimrc ~/.vimrc
  ```

- Note that `.gitignore_global` is automatically symlinked in `.zshrc`.

- Restart terminal, or source `.zshrc` (only after you've set the symlink)
  ```sh
  . ~/.zshrc
  ```

### An example `.zshrc_<VARIANT>` file
`~/.zshrc_work`
```sh
# Don't forget to symlink this file at `~/.zshrc`

# If not cloned to $HOME, modify DOTFILES to point to your copy of this repo
export DOTFILES="$HOME/.dotfiles"

source $DOTFILES/.zshrc # this file sources everything else (aliases, functions, etc.)

# Work-specific env vars, path additions, etc.
export LOG_SERVER_HOST='10.0.0.20'
export LOG_SERVER_USER='username'
export LOG_SERVER_PASS='super_secret_password'
export LOG_SERVER_ROOT='/home'

export RAILS_ENV="development"
export SQL_DATABASE_PASSWORD="allYourSQLAreBelongToMe"

export PATH="$HOME/.yarn/bin:$PATH" # Add path for Yarn
```

### A note about zsh custom plugins
The `.zshrc` and `.zshrc_<VARIANT>`s are pretty picky about how things were initially setup. For example, `k.sh`, `z.sh`, and `zsh-syntax-highlighting` all need to be in the `~/.oh-my-zsh/custom/plugin` directory (but if you move `z.sh`, leave `.z` in the home directory). `k.sh` and `z.sh` also need to be renamed using the ZSH plugin format. I.e.:
```sh
cp k.sh $ZSH_CUSTOM/plugins/k/k.plugin.zsh
cp z.sh $ZSH_CUSTOM/plugins/z/z.plugin.zsh
```

If you're not using all the plugins, just remove the relevant `plugins+=()` lines in `.zshrc`.
