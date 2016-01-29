# Scott Schupbach's custom .zshrc, aliases, and functions
This is just for me to make my terminal workflow more consistent between work and personal laptops, but if you've stumbled upon this and find any of it to be of use, by all means help yourself!

- Clone the dotfiles repo in your home directory or wherever
  ```sh
  git clone git@github.com:scottyschup/dotfiles.git ~/.dotfiles
  ```
  - If not ~, then change the $DOTFILES var in your .zshrc_variants

- create a .zshrc symlink to the .zshrc_VARIANT of your choosing in your home directory. (Change VARIANT to home, work, etc.)
  ```sh
  ln -s $DOTFILES/.zshrc_VARIANT ~/.zshrc
  ```

- Restart terminal

The .zshrc and .zshrc_VARIANTs are pretty picky about how things were initially setup. For example, k.sh, z.sh, and zsh-syntax-highlighting all need to be in the `.oh-my-zsh/custom/plugin` directory (but if you move z.sh, leave .z in the home directory). k.sh and z.sh also need to be put in plugin format. I.e.:
```sh
cp k.sh $ZSH_CUSTOM/plugins/k/k.plugin.zsh
cp z.sh $ZSH_CUSTOM/plugins/z/z.plugin.zsh
```

If you're not using all the plugins, just remove them from the `plugins=()` line in `.zshrc`.
