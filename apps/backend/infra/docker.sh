#!/bin/bash

# Helper script for Docker operations
# Usage: ./docker.sh [command]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored messages
print_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Commands
case "$1" in
    up)
        print_info "Starting services..."
        docker-compose up -d
        print_info "Services started! Application: http://localhost:3000"
        ;;
    
    down)
        print_info "Stopping services..."
        docker-compose down
        print_info "Services stopped"
        ;;
    
    build)
        print_info "Building images..."
        docker-compose build --no-cache
        print_info "Build complete"
        ;;
    
    rebuild)
        print_info "Rebuilding and starting services..."
        docker-compose down
        docker-compose build --no-cache
        docker-compose up -d
        print_info "Services restarted! Application: http://localhost:3000"
        ;;
    
    logs)
        if [ -z "$2" ]; then
            docker-compose logs -f
        else
            docker-compose logs -f "$2"
        fi
        ;;
    
    ps)
        docker-compose ps
        ;;
    
    restart)
        if [ -z "$2" ]; then
            print_info "Restarting all services..."
            docker-compose restart
        else
            print_info "Restarting $2..."
            docker-compose restart "$2"
        fi
        ;;
    
    exec)
        if [ -z "$2" ]; then
            print_error "Usage: ./docker.sh exec [service] [command]"
            exit 1
        fi
        service="$2"
        shift 2
        docker-compose exec "$service" "$@"
        ;;
    
    shell)
        service="${2:-app}"
        print_info "Opening shell in $service..."
        docker-compose exec "$service" sh
        ;;
    
    db)
        print_info "Connecting to database..."
        docker-compose exec db psql -U ecdkart -d ecdkart
        ;;
    
    migrate)
        print_info "Running database migrations..."
        docker-compose exec app pnpm drizzle-kit migrate
        ;;
    
    clean)
        print_warning "This will remove all containers and volumes!"
        read -p "Are you sure? (y/N) " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            print_info "Cleaning up..."
            docker-compose down -v
            print_info "Cleanup complete"
        else
            print_info "Cancelled"
        fi
        ;;
    
    health)
        print_info "Checking service health..."
        docker-compose ps
        echo ""
        print_info "Database health:"
        docker-compose exec db pg_isready -U ecdkart -d ecdkart || print_error "Database not healthy"
        echo ""
        print_info "Application health:"
        curl -f http://localhost:3000/api > /dev/null 2>&1 && print_info "Application is healthy" || print_error "Application not healthy"
        ;;
    
    help|*)
        echo "Usage: ./docker.sh [command]"
        echo ""
        echo "Commands:"
        echo "  up              Start all services in detached mode"
        echo "  down            Stop all services"
        echo "  build           Build all images from scratch"
        echo "  rebuild         Stop, rebuild, and start all services"
        echo "  logs [service]  View logs (all services or specific service)"
        echo "  ps              Show running containers"
        echo "  restart [svc]   Restart all or specific service"
        echo "  exec <svc> cmd  Execute command in service container"
        echo "  shell [service] Open shell in service (default: app)"
        echo "  db              Connect to PostgreSQL database"
        echo "  migrate         Run database migrations"
        echo "  clean           Remove all containers and volumes"
        echo "  health          Check health status of services"
        echo "  help            Show this help message"
        echo ""
        echo "Examples:"
        echo "  ./docker.sh up"
        echo "  ./docker.sh logs app"
        echo "  ./docker.sh shell app"
        echo "  ./docker.sh exec app pnpm test"
        echo "  ./docker.sh migrate"
        ;;
esac
