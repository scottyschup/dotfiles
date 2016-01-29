# Scott Schupbach's custom .zshrc, aliases, and functions

- Clone the dotfiles repo in your home directory or wherever
  ```bash
  git clone git@github.com:scottyschup/dotfiles.git
  ```
  - If not ~, then change the $DOTFILES var in your .zshrc_variants

- create a .zshrc symlink to the .zshrc_VARIANT of your choosing in your home directory. (Change VARIANT to home, work, etc.)
  ```bash
    ln -s ~/.dotfiles/.zshrc_VARIANT ~/.zshrc
  ```

- Restart terminal
