#!/usr/bin/env zsh

set -euo pipefail

SCRIPT_DIR="${0:A:h}"
REPO_ROOT="${SCRIPT_DIR:h:h}"

fail() {
  print -u2 -- "FAIL: $*"
  exit 1
}

assert_eq() {
  local expected="$1"
  local actual="$2"
  local message="${3:-values differ}"

  if [[ "$expected" != "$actual" ]]; then
    fail "$message\nexpected: $expected\nactual:   $actual"
  fi
}

make_temp_dir() {
  mktemp -d "${REPO_ROOT}/tmp/zsh-test.XXXXXX"
}

make_fake_lsof() {
  local fake_lsof_path="$1"

  cat >"$fake_lsof_path" <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

case "$*" in
  *":3000"*)
    if [[ "$*" == *"-tnPi"* ]]; then
      printf '111\n'
    else
      printf 'ruby 111 user 0t0 TCP *:3000 (LISTEN)\n'
    fi
    ;;
  *":3001"*)
    if [[ "$*" == *"-tnPi"* ]]; then
      printf '222\n'
    else
      printf 'node 222 user 0t0 TCP *:3001 (LISTEN)\n'
    fi
    ;;
  *)
    :
    ;;
esac
EOF

  chmod +x "$fake_lsof_path"
}

test_pid_mode_returns_pids() {
  local temp_dir fake_bin output rc
  temp_dir="$(make_temp_dir)"
  fake_bin="$temp_dir/bin"
  mkdir -p "$fake_bin"
  make_fake_lsof "$fake_bin/lsof"

  set +e
  output="$(PATH="$fake_bin:$PATH" RED='[RED]' YLW='[YLW]' CYN='[CYN]' NONE='[NONE]' PPL='[PPL]' "$REPO_ROOT/scripts/port_checker_local" pid 3000 3001 2>&1)"
  rc=$?
  set -e
  rm -rf "$temp_dir"

  assert_eq 0 "$rc" 'port_checker_local pid mode should succeed'
  assert_eq $'111\n222' "$output" 'port_checker_local pid mode output'
}

test_non_numeric_port_errors() {
  local rc output
  set +e
  output="$(RED='[RED]' YLW='[YLW]' CYN='[CYN]' NONE='[NONE]' PPL='[PPL]' "$REPO_ROOT/scripts/port_checker_local" abc 2>&1)"
  rc=$?
  set -e

  assert_eq 3 "$rc" 'port_checker_local should reject non-numeric ports'
  [[ "$output" == *"Port 'abc' is not a number"* ]] || fail "expected numeric validation error"
}

main() {
  test_pid_mode_returns_pids
  print -- 'ok - test_pid_mode_returns_pids'
  test_non_numeric_port_errors
  print -- 'ok - test_non_numeric_port_errors'
  print -- '2 tests passed'
}

main "$@"
