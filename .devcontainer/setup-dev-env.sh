#!/usr/bin/env bash

set -euo pipefail

env_file="${APP_DIR}/.env"

# Export all environment variables
if [[ -f "$env_file" ]]; then
  set -a
  # shellcheck source="../.env"
  . "$env_file"
  set +a

  # Configure Exercism
  exercism configure --token "$EXERCISM_TOKEN" --workspace "$APP_DIR"
else
  echo "WARNING: .env file missing"
fi
