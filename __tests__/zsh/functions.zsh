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

assert_contains() {
  local haystack="$1"
  local needle="$2"
  local message="${3:-missing expected text}"

  if [[ "$haystack" != *"$needle"* ]]; then
    fail "$message\nneedle: $needle\noutput: $haystack"
  fi
}

make_temp_dir() {
  mktemp -d "${REPO_ROOT}/tmp/zsh-test.XXXXXX"
}

test_psaux_with_grep_and_pids_for() {
  PS_OUTPUT=$'USER   PID  COMMAND\nalice 111 node server\nalice 222 grep node\nalice 333 rails server\nalice 444 grep rails'
  function ps() {
    print -r -- "$PS_OUTPUT"
  }

  source "$REPO_ROOT/.functions" >/dev/null

  local ps_output pids_output
  ps_output="$(psaux_with_grep node)"
  pids_output="$(pids_for node)"

  assert_contains "$ps_output" 'node server' 'psaux_with_grep should surface matching ps output'
  assert_contains "$ps_output" 'grep node' 'psaux_with_grep should include grep process line'
  assert_eq '111' "$pids_output" 'pids_for should extract the pid and drop grep'
}

test_omni_killer_uses_pids_for_and_kill() {
  local temp_dir kill_log
  temp_dir="$(make_temp_dir)"
  kill_log="$temp_dir/kill.log"

  PS_OUTPUT=$'USER   PID  COMMAND\nalice 111 node server\nalice 222 grep node'
  function ps() {
    print -r -- "$PS_OUTPUT"
  }

  function kill() {
    print -r -- "$*" >> "$kill_log"
    return 0
  }

  source "$REPO_ROOT/.functions" >/dev/null

  local killer_output kill_calls
  killer_output="$(omni_killer node)"
  kill_calls="$(<"$kill_log")"

  assert_contains "$killer_output" '1 node process terminated: 111.' 'omni_killer should report one killed pid'
  assert_eq $'-9 111' "$kill_calls" 'omni_killer should invoke kill on the extracted pid'

  rm -rf "$temp_dir"
}

test_kill_ports_uses_on_port_and_kill() {
  local temp_dir kill_log
  temp_dir="$(make_temp_dir)"
  kill_log="$temp_dir/kill.log"

  function on_port() {
    case "$2" in
      3000) print -r -- '111' ;;
      3001) print -r -- '222' ;;
      *) : ;;
    esac
  }

  function kill() {
    print -r -- "$*" >> "$kill_log"
    return 0
  }

  source "$REPO_ROOT/.aliases-post-scripts" >/dev/null

  local kill_output kill_calls
  kill_output="$(kill_ports $'3000\n3001')"
  kill_calls="$(<"$kill_log")"

  assert_contains "$kill_output" 'Killing process' 'kill_ports should announce killed processes'
  assert_eq $'-9 111\n-9 222' "$kill_calls" 'kill_ports should call kill for each port'

  rm -rf "$temp_dir"
}

main() {
  test_psaux_with_grep_and_pids_for
  print -- 'ok - test_psaux_with_grep_and_pids_for'
  test_omni_killer_uses_pids_for_and_kill
  print -- 'ok - test_omni_killer_uses_pids_for_and_kill'
  test_kill_ports_uses_on_port_and_kill
  print -- 'ok - test_kill_ports_uses_on_port_and_kill'
  print -- '3 tests passed'
}

main "$@"
