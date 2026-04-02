---
name: terminal-workaround
description: Instructions for handling terminal commands that produce large outputs or have unpredictable execution times.
---

# Instructions for Terminal Workarounds

Always run terminal commands in a background terminal and then read its captured output directly.

When running shell commands that produce more than ~50 lines of output,
ALWAYS redirect output to a temporary file and read the file afterward.

Do not attempt to capture large command output directly from the terminal.

Don't use your default timeouts to know when to stop waiting for a response from the terminal. If you reach the timeout threshold, reset the timer and wait again. If you reach the timeout threshold again, wait a third time. Only after three consecutive timeouts should you conclude that the command has finished executing and proceed to read the output file.

Use (or create) a `./tmp` folder at the project root.

Pattern:
```sh
  <command> > ./tmp/cmd-output.log 2>&1; echo "EXIT:$?" >> ./tmp/cmd-output.log
  # then read ./tmp/cmd-output.log
```
This applies especially to: test runners, build commands, linters, and any Nx targets.
