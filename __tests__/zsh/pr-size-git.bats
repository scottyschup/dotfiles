#!/usr/bin/env bats

# Test helper to get the script path
get_script() {
  echo "${BATS_TEST_DIRNAME}/../../scripts/pr-size-git"
}

# Setup: ensure we're in a git repo
setup() {
  SCRIPT="$(get_script)"
  TEMP_DIR="$(mktemp -d)"
  cd "$TEMP_DIR"
  git init > /dev/null 2>&1
  git config user.email "test@example.com"
  git config user.name "Test User"

  # Create initial commit on main
  echo "initial" > README.md
  git add README.md
  git commit -m "initial commit" > /dev/null 2>&1
  git branch -M main
  git branch origin/main
}

# Teardown: clean up temp directory
teardown() {
  cd /
  rm -rf "$TEMP_DIR"
}

@test "help flag shows usage" {
  run "$SCRIPT" -H
  [ $status -eq 1 ]
  [[ "$output" =~ "Usage:" ]]
  [[ "$output" =~ "Options:" ]]
}

@test "--help flag shows usage" {
  run "$SCRIPT" --help
  [ $status -eq 1 ]
  [[ "$output" =~ "Usage:" ]]
}

@test "-h short flag for head works" {
  run "$SCRIPT" -h HEAD
  [ $status -eq 0 ]
  [[ "$output" =~ "Range:" ]]
}

@test "invalid flag shows error" {
  run "$SCRIPT" --invalid
  [ $status -eq 1 ]
  [[ "$output" =~ "Unknown option" ]]
}

@test "--base flag accepts value" {
  # Create a test branch
  git checkout -b test-branch > /dev/null 2>&1
  echo "test" > test.md
  git add test.md
  git commit -m "add test file" > /dev/null 2>&1

  run "$SCRIPT" --base HEAD --head HEAD
  [ $status -eq 0 ]
  [[ "$output" =~ "Range:" ]]
}

@test "-b short flag for base works" {
  git checkout -b test-branch > /dev/null 2>&1
  echo "test" > test.md
  git add test.md
  git commit -m "add test file" > /dev/null 2>&1

  run "$SCRIPT" -b HEAD --head HEAD
  [ $status -eq 0 ]
  [[ "$output" =~ "Range:" ]]
}

@test "--head flag accepts value" {
  git checkout -b test-branch > /dev/null 2>&1
  echo "test" > test.md
  git add test.md
  git commit -m "add test file" > /dev/null 2>&1

  run "$SCRIPT" --base main --head HEAD
  [ $status -eq 0 ]
  [[ "$output" =~ "Range:" ]]
}

@test "-u flag for uncommitted changes" {
  git checkout -b test-branch > /dev/null 2>&1
  echo "test" > test.md
  git add test.md
  git commit -m "add test file" > /dev/null 2>&1

  # Make uncommitted changes
  echo "uncommitted" >> test.md

  run "$SCRIPT" -u
  [ $status -eq 0 ]
  [[ "$output" =~ "Range:" ]]
}

@test "--include-uncommitted flag works" {
  git checkout -b test-branch > /dev/null 2>&1
  echo "test" > test.md
  git add test.md
  git commit -m "add test file" > /dev/null 2>&1

  # Make uncommitted changes
  echo "uncommitted" >> test.md

  run "$SCRIPT" --include-uncommitted
  [ $status -eq 0 ]
  [[ "$output" =~ "Range:" ]]
}

@test "output includes Range, Files changed, Insertions, Deletions, Lines changed, and Overall PR rank" {
  git checkout -b test-branch > /dev/null 2>&1
  echo "test" > test.md
  git add test.md
  git commit -m "add test file" > /dev/null 2>&1

  run "$SCRIPT" --base main --head HEAD
  [ $status -eq 0 ]
  [[ "$output" =~ "Range:" ]]
  [[ "$output" =~ "Files changed:" ]]
  [[ "$output" =~ "Insertions:" ]]
  [[ "$output" =~ "Deletions:" ]]
  [[ "$output" =~ "Lines changed:" ]]
  [[ "$output" =~ "Overall PR rank" ]]
}

@test "combining --base and --head flags" {
  git checkout -b feature > /dev/null 2>&1
  echo "feature work" > feature.md
  git add feature.md
  git commit -m "feature commit" > /dev/null 2>&1

  run "$SCRIPT" --base main --head feature
  [ $status -eq 0 ]
  [[ "$output" =~ "Range:" ]]
  [[ "$output" =~ "main" ]]
}

@test "combining -b and --head flags" {
  git checkout -b feature > /dev/null 2>&1
  echo "feature work" > feature.md
  git add feature.md
  git commit -m "feature commit" > /dev/null 2>&1

  run "$SCRIPT" -b main --head feature
  [ $status -eq 0 ]
  [[ "$output" =~ "Range:" ]]
}

@test "combining --base, --head, and --include-uncommitted flags" {
  git checkout -b feature > /dev/null 2>&1
  echo "feature work" > feature.md
  git add feature.md
  git commit -m "feature commit" > /dev/null 2>&1

  # Add uncommitted changes
  echo "uncommitted" >> feature.md

  run "$SCRIPT" --base main --head feature --include-uncommitted
  [ $status -eq 0 ]
  [[ "$output" =~ "Range:" ]]
}

@test "combining -b and -u flags" {
  git checkout -b feature > /dev/null 2>&1
  echo "feature work" > feature.md
  git add feature.md
  git commit -m "feature commit" > /dev/null 2>&1

  # Add uncommitted changes
  echo "uncommitted" >> feature.md

  run "$SCRIPT" -b main -u
  [ $status -eq 0 ]
  [[ "$output" =~ "Range:" ]]
}

@test "error when base ref does not exist" {
  run "$SCRIPT" --base nonexistent --head HEAD
  [ $status -ne 0 ]
  [[ "$output" =~ "Error" ]]
  [[ "$output" =~ "does not exist" ]]
}

@test "error when head ref does not exist" {
  run "$SCRIPT" --base main --head nonexistent
  [ $status -ne 0 ]
  [[ "$output" =~ "Error" ]]
  [[ "$output" =~ "does not exist" ]]
}

@test "error when not in a git repository" {
  cd /tmp
  run "$SCRIPT"
  [ $status -ne 0 ]
  [[ "$output" =~ "not inside a git repository" ]]
}

@test "output shows classification for small PRs as normal" {
  git checkout -b small-change > /dev/null 2>&1
  echo "x" >> README.md
  git add README.md
  git commit -m "small change" > /dev/null 2>&1

  run "$SCRIPT" --base main --head small-change
  [ $status -eq 0 ]
  [[ "$output" =~ "normal" ]]
}
