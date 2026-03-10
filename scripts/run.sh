#!/usr/bin/env bash

command="$1"

if [ -z "$command" ]; then
  command="start"
fi

# Resolve project root relative to this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$SCRIPT_DIR/.."

export AMBULANCE_API_ENVIRONMENT="Development"
export AMBULANCE_API_PORT="8080"

case "$command" in
  start)
    go run "$PROJECT_ROOT/cmd/ambulance-api-service"
    ;;
  openapi)
    docker run --rm -ti \
      -v "$PROJECT_ROOT:/local" \
      openapitools/openapi-generator-cli \
      generate -c /local/scripts/generator-cfg.yaml
    ;;
  *)
    echo "Unknown command: $command"
    exit 1
    ;;
esac
