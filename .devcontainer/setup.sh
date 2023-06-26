#!/usr/bin/env bash

set -euo pipefail

readonly env_file="$APP_DIR/.env"

function main() {
  validate_env_file
  export_env_vars
  validate_exercism_token
  configure_exercism
}

function export_env_vars() {
  set -a
  # shellcheck source="../.env"
  . "$env_file"
  set +a
}

function configure_exercism() {
  exercism configure --token "$EXERCISM_TOKEN" --workspace "$APP_DIR" \
    &>/dev/null &&
    print "Exercism configured successfully."
}

function validate_env_file() {
  if [[ ! -f $env_file ]]; then
    print "WARNING: .env file missing. Exercism configuration aborted."
    exit 0
  fi
}

function validate_exercism_token() {
  if [[ -z $EXERCISM_TOKEN ]]; then
    print "WARNING: EXERCISM_TOKEN is empty. Exercism configuration aborted."
    exit 0
  fi
}

function print() {
  printf "%b\n" "$@"
}

main
