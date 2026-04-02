# Tests

This directory contains automated tests for scripts in the dotfiles repository.

## Running Tests

### All Tests

Run every discovered test file automatically:

```bash
./scripts/run-tests
```

### zsh Tests

Run the shell helper tests directly with zsh:

```bash
zsh zsh/test_port_helpers.zsh
```

If you have [BATS](https://github.com/bats-core/bats-core) installed, you can also run the existing PR size test:

```bash
bats zsh/pr-size-git.bats
```

### Ruby Tests

Run the Ruby suites directly:

```bash
ruby ruby/test_on_port_and_pingrb.rb
ruby ruby/test_script_helpers.rb
```

## Test Coverage

### zsh/pr-size-git.bats

Tests the `pr-size-git` script with comprehensive coverage of:

- **Help documentation**: `--help` and `-h` flags
- **Base branch flag**: `--base` and `-b` short form
- **Head branch flag**: `--head` long form
- **Uncommitted changes**: `-u` and `--include-uncommitted` flags
- **Flag combinations**: Multiple flags used together
- **Output validation**: Verifies all expected output fields
- **Error handling**: Invalid refs, missing repos, unknown flags
- **Classifications**: Normal, large, too big, exceptional PR sizes

### zsh/port_checker_local.zsh

Tests the `port_checker_local` script.

### zsh/on_port.zsh

Tests the `on_port` wrapper script.

### zsh/functions.zsh

Tests helper functions sourced from `.functions` and `.aliases-post-scripts`:

- `psaux_with_grep`
- `pids_for`
- `omni_killer`
- `kill_ports`

### ruby/pingrb_test.rb

Tests the `pingrb` Ruby script.

- `PingRb` constructor arguments
- `PingTracker` default and multi-argument initialization

### ruby/enova-state-product_test.rb

Tests the `enova-state-product` Ruby script.

### ruby/new_script_test.rb

Tests the `new_script` Ruby script.

### ruby/remind_me_test.rb

Tests the `remind_me` Ruby script.

## Layout

- `zsh/` contains shell tests
- `ruby/` contains Ruby tests and their support stubs
