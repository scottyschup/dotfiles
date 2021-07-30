# Setup (for Mac)
## `curl-cmanv2`
### Make all the calls to the camapaignmanager API service that your heart desires!
These are the directory and file the script will live in; feel free to change these as needed to fit your environment:
```sh
curlcmanv2_root_dir="$HOME/.curlcmanv2"
curlcmanv2_script="$curlcmanv2_root_dir/curl-cmanv2"
mkdir -p $curlcmanv2_root_dir
curl "https://raw.githubusercontent.com/scottyschup/dotfiles/main/scripts/curl-cmanv2" > $curlcmanv2_script
chmod +x $curlcmanv2_script
```

## `token-fridge`
### Keep your token fresh and crisp all day long!
This needs the `curl-cmanv2` script from the same `scripts` directory to work (see setup instructions above).
```sh
token_fridge_script="$curlcmanv2_root_dir/token-fridge"
curl "https://raw.githubusercontent.com/scottyschup/dotfiles/main/scripts/token-fridge" > $token_fridge_script
chmod +x $token_fridge_script
```

## Final steps
The following adds the `.curlcmanv2` dir to your path so you can run the scripts with `curl-cmanv2`
and `token-fridge` rather than having to type `~/.curlcmanv2/curl-cmanv2` or `~/.curlcmanv2/curl-cmanv2`
respectively each time.

**Note**: change the path/name for your `.zshrc` if it's not in your home dir, it's named something else, or
you use a different shell.
```
echo "export PATH=$curlcmanv2_root_dir"':$PATH' >> $HOME/.zshrc
```

# Usage
Both commands have a simple interactive UI for collecting the necessary data.

`curl-cmanv2` will ask for a few different peices of information, however aside from the
cookie, all other values have defaults to fallback on. If you don't want to go through the prompts
for optional values, just use the `-P` flag (note: capital-P).

You can also pass in the cookie with the `-c` flag. Be sure to wrap values with spaces or
non-alphanumeric characters in double-quotes when using the flags, but do not include quotes around
values when responding to the command prompts.
```sh
curl-cmanv2 -P -c "YOUR_COOKIE_STRING_HERE_IN_DOUBLE_QUOTES"
```
but
```sh
$ curl-cmanv2

Enter a valid cookie [REQUIRED] (paste from the headers of a recent RallyEngine call to the desired tenant):
> YOUR_COOKIE_STRING_HERE_WITHOUT_QUOTES
```

If you've already entered a cookie that's still valid and don't need to override any default values,
you can use the `-l` flag to use the same values from the previous call.
```sh
curl-cmanv2 -l
```

Since `token-fridge` is just a long-running script that uses `curl-cmanv2` in a very specific way,
you will only need to provide a valid cookie. The same `-c` flag can be used to pass the cookie in,
and the same `-l` flag can be added to reuse the values from the previous call.

Run each command with the `-h` flag for options help.
```sh
curl-cmanv2 -h
token-fridge -h
```
