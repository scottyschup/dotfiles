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

test_wrapper_delegates_to_port_checker_local() {
  local temp_dir fake_bin output rc
  temp_dir="$(make_temp_dir)"
  fake_bin="$temp_dir/bin"
  mkdir -p "$fake_bin"
  make_fake_lsof "$fake_bin/lsof"

  set +e
  output="$(PATH="$fake_bin:$PATH" RED='[RED]' YLW='[YLW]' CYN='[CYN]' NONE='[NONE]' PPL='[PPL]' "$REPO_ROOT/scripts/on_port" pid 3000 3001 2>&1)"
  rc=$?
  set -e
  rm -rf "$temp_dir"

  assert_eq 0 "$rc" 'on_port should succeed'
  assert_eq $'111\n222' "$output" 'on_port should delegate to port_checker_local'
}

main() {
  test_wrapper_delegates_to_port_checker_local
  print -- 'ok - test_wrapper_delegates_to_port_checker_local'
  print -- '1 test passed'
}

main "$@"
