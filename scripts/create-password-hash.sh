#!/usr/bin/env bash
set -euo pipefail

output="${1:-/tmp/austin-password-hash}"

if [[ "$output" != /* ]]; then
  printf 'Output path must be absolute\n' >&2
  exit 1
fi

password_hash="$(nix run nixpkgs#mkpasswd -- --method=yescrypt)"

sudo install -m 0600 -o root -g root /dev/null "$output"
printf '%s\n' "$password_hash" |
  sudo dd of="$output" status=none

unset password_hash

sudo stat -c '%U:%G %a %s %n' "$output"
