# GitHub Copilot Instructions for Dotfiles Repository

## Project Overview
This is a personal dotfiles repository containing shell configuration, utility scripts, and development environment customizations for macOS. The repository includes:
- Custom shell scripts for terminal workflow automation
- Git workflow utilities
- Developer productivity tools
- VS Code and Sublime Text configurations
- Ruby CLI utilities and helpers

## General Conventions

### File Organization
- **`scripts/`**: Executable utility scripts (no file extensions)
- **`lib/rb/`**: Reusable Ruby libraries and modules
- **`vscode/`**: VS Code settings and configurations
- **`templates/`**: Template files for various purposes
- **`install/`**: Setup and installation scripts

### Coding Standards
- **Indentation**: Use 2 spaces (never tabs)
- **Line Length**: Prefer 80-120 characters; use 125 as hard limit
- **Trailing Whitespace**: Remove trailing whitespace (except in Markdown files)
- **Final Newline**: Always include final newline in files

## Ruby Scripts

### Shebang and Structure
- Always start with: `#!/usr/bin/env ruby -w`
- The `-w` flag enables warnings
- Scripts should be executable (`chmod +x`)

### Common Patterns
```ruby
#!/usr/bin/env ruby -w

# Include usage/help function
def usage
  $stdout.puts "Usage: script_name [OPTIONS] ARGS"
end

# Check for help flags
if ARGV[0]&.include?("-h")
  usage
  exit
end

# Dependency management with error handling
begin
  verbose = $VERBOSE
  $VERBOSE = nil # Suppress deprecation warnings

  require 'optparse'
  require_relative '../lib/rb/cli_utils'
rescue LoadError => err
  dependency = err.message.split(' -- ').last.split('/').first
  warn "Missing dependency: #{dependency}"
  warn "Install with: gem install #{dependency}"
  exit 1
ensure
  $VERBOSE = verbose
end
```

### CLI Output Standards
- Use `CLIUtils` class for colorized output (from `lib/rb/cli_utils.rb`)
- Message types: `:log`, `:info`, `:warn`, `:error`, `:success`, `:partial`
- Use `$stdout.puts` instead of `puts` for standard output
- Use `$stderr` or `warn` for error messages

### Argument Parsing
- Separate flags from positional arguments:
  ```ruby
  args = ARGV.reject { |el| el.start_with?('--') }
  flags = ARGV.select { |el| el.start_with?('--') }.join(' ')
  ```
- Provide sensible defaults
- Validate required arguments before processing

### Command Execution
- Use backticks for simple shell commands: `` `git branch` ``
- Capture and process command output appropriately
- Handle command failures gracefully

## Bash/Zsh Scripts

### Shebang Options
- Prefer: `#!/usr/bin/env zsh` or `#! /usr/bin/env zsh`
- For bash: `#!/usr/bin/env bash`

### Color Variables
Use color variables defined in .colors file:
- `$RED` - Error messages
- `$YLW` - Warnings and highlights
- `$PPL` - Purple for labels
- `$CYN` - Cyan for info
- `$GRN` - Green for success
- `$NONE` - Reset color

### Argument Validation
```bash
# Check for required arguments
if [ ! $1 ]; then
  echo "$RED""ArgumentError:$NONE expected arguments but got none"
  echo "\tUsage: script_name ARG1 [ARG2 ...]"
  exit 1
fi

# Validate numeric arguments
num_re='^[0-9]+$'
if [[ ! "$arg" =~ "$num_re" ]]; then
  echo "$RED""ArgumentError:$NONE '$arg' is not a number"
  exit 3
fi
```

### Error Handling
- Use non-zero exit codes for errors (1, 2, 3, etc.)
- Provide clear error messages with color coding
- Include usage hints in error messages

## Git-Related Scripts

### Naming Convention
- Prefix with `git_` or `git-` for git automation scripts
- Examples: `git_push_set_upstream`, `git-orphaned-branches`

### Common Patterns
- Default to `origin` remote when not specified
- Use `git symbolic-ref HEAD` to get current branch
- Suppress error output with `2>/dev/null` when appropriate
- Provide dry-run or verbose modes where applicable

## Script Naming and Conventions

### File Naming
- Use snake_case for script names
- No file extensions for executable scripts in `scripts/`
- Descriptive names indicating purpose (e.g., `clear-port`, `port_checker_local`)

### Script Structure
1. Shebang line
2. Usage/help function (if accepting arguments)
3. Help flag handling (`-h`, `--help`)
4. Dependency loading/validation
5. Argument parsing and validation
6. Main logic
7. Output/exit with appropriate code

## Development Tools and Utilities

### Port and Process Management
- Scripts exist for checking ports (`port_checker_local`, `port_checker_remote`)
- Use `lsof` for port checking: `lsof -nPi :PORT`
- Process termination via `terminate` script

### Network and System Tools
- Prefer built-in commands (`lsof`, `ps aux`, `curl`)
- Parse command output with Ruby or standard Unix tools
- Colorize output for better readability

## VS Code Integration

### Extension Preferences
- Ruby LSP (Shopify.ruby-lsp) for Ruby development
- ESLint for JavaScript linting
- Prefer explicit formatting (`formatOnSave: false` by default, except Ruby)

### Editor Settings
- Font: 'Fira Code', 'Source Code Pro', Monaco
- Font size: 12
- Tab size: 2 spaces
- Render whitespace: all
- Rulers at 80 and 125 characters

## When Creating New Scripts

### Use `new_script` Helper
There's a `new_script` utility to scaffold new scripts:
```bash
new_script SCRIPT_NAME [LANGUAGE] [FLAGS]
```

### Templates to Follow
- **Ruby script**: Include usage function, help handling, CLIUtils integration
- **Bash/Zsh script**: Include color variables, argument validation, error handling
- Make scripts executable with `chmod +x`

## Dependencies

### Ruby Gems
- `colorize` - For terminal color output
- `optparse` - For argument parsing (standard library)

### External Tools
Common Unix tools used:
- `lsof` - Process and port information
- `git` - Version control automation
- `curl` - HTTP requests
- `grep`, `awk`, `sed` - Text processing

## Best Practices

1. **Always validate input** - Check arguments before processing
2. **Provide helpful error messages** - Include usage hints
3. **Use appropriate exit codes** - 0 for success, non-zero for errors
4. **Colorize output** - Use color variables or CLIUtils for clarity
5. **Handle edge cases** - Empty input, missing dependencies, failed commands
6. **Keep scripts focused** - One script, one clear purpose
7. **Document complex logic** - Add comments for non-obvious code
8. **Test with edge cases** - Empty args, invalid input, missing files
9. **Use relative paths** - Especially for `require_relative` in Ruby
10. **Suppress unnecessary output** - Use `-q`, `2>/dev/null`, or `$VERBOSE = nil`

## Code Style

### Ruby
- Use Ruby 2.4+ features
- Prefer safe navigation (`&.`)
- Use string interpolation over concatenation
- Use symbols for hash keys and method arguments
- Use heredocs for multi-line strings (`<<~HEREDOC`)
- Prefer `each` over `for` loops

### Shell Scripts
- Quote variables: `"$var"` not `$var`
- Use `[[ ]]` for conditionals (not `[ ]`)
- Prefer `$()` over backticks in bash (but backticks are fine in zsh)
- Use meaningful variable names
- Use functions for repeated logic

## Testing and Debugging

### Ruby Scripts
- Test with the `-w` warning flag (already in shebang)
- Use `$VERBOSE` toggle for optional warning suppression
- Test with various argument combinations
- Verify exit codes

### Shell Scripts
- Test with `set -e` for debugging (exit on error)
- Use `echo` for debugging variable values
- Test with edge cases (empty strings, special characters)

## Maintenance

### When Updating Scripts
- Maintain backward compatibility when possible
- Update usage/help text if changing arguments
- Test on macOS (primary environment)
- Consider dependencies and availability of external commands

### When Adding New Utilities
- Check for existing similar functionality
- Follow established naming conventions
- Add to appropriate directory (`scripts/` vs `lib/`)
- Document any special setup or dependencies
