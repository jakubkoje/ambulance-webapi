#!/usr/bin/env bash

command="$1"
if [ -z "$command" ]; then
  command="start"
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$SCRIPT_DIR/.."

export AMBULANCE_API_ENVIRONMENT="Development"
export AMBULANCE_API_PORT="8080"
export AMBULANCE_API_MONGODB_USERNAME="root"
export AMBULANCE_API_MONGODB_PASSWORD="neUhaDnes"

mongo() {
  docker compose --file "$PROJECT_ROOT/deployments/docker-compose/compose.yaml" "$@"
}

case "$command" in
  openapi)
    docker run --rm -ti \
      -v "$PROJECT_ROOT:/local" \
      openapitools/openapi-generator-cli \
      generate -c /local/scripts/generator-cfg.yaml
    ;;

  start)
    trap 'mongo down' EXIT
    mongo up --detach
    go run "$PROJECT_ROOT/cmd/ambulance-api-service"
    ;;

  mongo)
    mongo up
    ;;

  test)
    go test -v ./...
    ;;

  *)
    echo "Unknown command: $command"
    exit 1
    ;;
esac
