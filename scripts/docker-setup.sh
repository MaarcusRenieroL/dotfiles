#!/usr/bin/env bash
# Setup Docker and launch development containers
set -euo pipefail

DOTFILES="${DOTFILES:=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
export DOTFILES
# shellcheck source=scripts/lib.sh
source "$DOTFILES/scripts/lib.sh"

hr "Docker Setup"

# Check if Docker is installed
if ! have docker; then
  err "Docker is not installed. Please install Docker Desktop from https://www.docker.com/products/docker-desktop"
  exit 1
fi

ok "Docker installed: $(docker --version)"

# Check if Docker daemon is running
if ! docker ps > /dev/null 2>&1; then
  err "Docker daemon is not running. Please start Docker Desktop."
  exit 1
fi

ok "Docker daemon is running"

# Start containers from docker-compose.yml
hr "Starting development containers"
info "Launching PostgreSQL, MySQL, Redis, Java, and Node.js containers..."

cd "$DOTFILES"
docker-compose up -d

# Wait for services to be healthy
info "Waiting for services to be healthy..."
sleep 5

# Check service status
hr "Service Status"
docker-compose ps

ok "All containers started successfully!"
info ""
info "Service Connection Details:"
info "  PostgreSQL: localhost:5432 (user: postgres, password: postgres)"
info "  MySQL:      localhost:3306 (user: root, password: root)"
info "  Redis:      localhost:6379"
info ""
info "To access a container:"
info "  docker-compose exec postgres psql -U postgres"
info "  docker-compose exec mysql mysql -u root -p"
info "  docker-compose exec redis redis-cli"
info "  docker-compose exec java bash"
info "  docker-compose exec node bash"
info ""
info "To stop all containers:"
info "  docker-compose down"
