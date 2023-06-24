#!/usr/bin/env bash

set -euo pipefail

env_file="$APP_DIR/.env"

if [[ ! -f $env_file ]]; then
  echo "WARNING: .env file missing"
elif [[ -z $EXERCISM_TOKEN ]]; then
  echo "WARNING: EXERCISM_TOKEN is empty"
else
  # Export all environment variables
  set -a
  # shellcheck source="../.env"
  . "$env_file"
  set +a

  # Configure Exercism
  exercism configure --token $EXERCISM_TOKEN --workspace "$APP_DIR" \
    &>/dev/null &&
    echo "Exercism configured successfully."
fi
