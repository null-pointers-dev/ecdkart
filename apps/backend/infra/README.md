# Docker Infrastructure for ecdkart Backend

This directory contains Docker configuration for running the ecdkart NestJS backend and PostgreSQL database.

## Structure

- `Dockerfile.app` - Dockerfile for the NestJS application
- `Dockerfile.db` - Dockerfile for PostgreSQL database
- `docker-compose.yml` - Docker Compose orchestration file
- `.dockerignore` - Files to ignore when building Docker images

## Quick Start

### Prerequisites

- Docker installed (version 20.10+)
- Docker Compose installed (version 2.0+)

### Using Helper Script (Recommended)

The easiest way to work with Docker is using the provided helper script:

```bash
# Make script executable (first time only)
chmod +x docker.sh

# Start services
./docker.sh up

# View logs
./docker.sh logs

# Stop services
./docker.sh down

# See all available commands
./docker.sh help
```

### Build and Run (Manual)

From the `infra` directory:

```bash
# Build and start all services
docker-compose up --build

# Run in detached mode (background)
docker-compose up -d --build

# View logs
docker-compose logs -f

# View logs for specific service
docker-compose logs -f app
docker-compose logs -f db
```

### Stop Services

```bash
# Stop all services
docker-compose down

# Stop and remove volumes (WARNING: deletes database data)
docker-compose down -v
```

## Services

### Database (db)

- **Container name**: `ecdkart-db`
- **Port**: 5432
- **Database**: ecdkart
- **User**: ecdkart
- **Password**: ecdkart_password (change in production!)
- **Volume**: `postgres_data` for data persistence

### Application (app)

- **Container name**: `ecdkart-app`
- **Port**: 3000
- **API Endpoint**: http://localhost:3000/api
- **Dependencies**: Waits for database to be healthy before starting

## Environment Variables

You can customize environment variables in `docker-compose.yml` or create a `.env` file:

```env
# Database
POSTGRES_DB=ecdkart
POSTGRES_USER=ecdkart
POSTGRES_PASSWORD=ecdkart_password

# Application
NODE_ENV=production
PORT=3000
DATABASE_URL=postgresql://ecdkart:ecdkart_password@db:5432/ecdkart
```

## Database Migrations

To run database migrations:

```bash
# Access the app container
docker-compose exec app sh

# Run migrations using drizzle-kit
pnpm drizzle-kit migrate

# Or if you have a migration script
pnpm migrate
```

Alternatively, you can run migrations from your host machine (if the database port is exposed):

```bash
# From the backend directory
cd apps/backend
DATABASE_URL=postgresql://ecdkart:ecdkart_password@localhost:5432/ecdkart pnpm drizzle-kit migrate
```

## Database Access

To access the PostgreSQL database:

```bash
# Using docker-compose
docker-compose exec db psql -U ecdkart -d ecdkart

# Using psql from host (if port is exposed)
psql -h localhost -p 5432 -U ecdkart -d ecdkart
```

## Development vs Production

### Development Setup

For local development with hot-reload, use the development Docker Compose file:

```bash
# Start development environment
docker-compose -f docker-compose.dev.yml up --build

# Or in detached mode
docker-compose -f docker-compose.dev.yml up -d --build

# Stop development environment
docker-compose -f docker-compose.dev.yml down
```

**Development features:**
- Hot-reload enabled (source code mounted as volume)
- Debug port exposed (9229)
- Development database (ecdkart_dev)
- Separate volumes to avoid conflicts

### Production Setup

Use the main `docker-compose.yml` for production:

```bash
docker-compose up -d --build
```

**Production considerations:**
- Change default passwords in environment variables
- Use secrets management (Docker secrets, Kubernetes secrets, etc.)
- Add proper logging and monitoring
- Use environment-specific compose files
- Consider using a managed database service
- Set up SSL/TLS for the application
- Configure proper resource limits

## Troubleshooting

### Application won't start

```bash
# Check logs
docker-compose logs app

# Ensure database is healthy
docker-compose ps
```

### Database connection issues

```bash
# Check database is running
docker-compose ps db

# Check database logs
docker-compose logs db

# Verify connection from app container
docker-compose exec app sh
nc -zv db 5432
```

### Rebuild from scratch

```bash
# Remove all containers, volumes, and rebuild
docker-compose down -v
docker-compose build --no-cache
docker-compose up
```

## Network

All services run on a custom bridge network called `ecdkart-network`. Services can communicate using their service names (e.g., `db`, `app`).

## Health Checks

Both services have health checks configured:
- **Database**: Checks PostgreSQL is ready using `pg_isready`
- **Application**: Checks HTTP endpoint returns 200 status

## Volumes

- `postgres_data`: Persists PostgreSQL database data

To backup the database volume:

```bash
docker run --rm -v ecdkart_postgres_data:/data -v $(pwd):/backup alpine tar czf /backup/db-backup.tar.gz /data
```

To restore:

```bash
docker run --rm -v ecdkart_postgres_data:/data -v $(pwd):/backup alpine tar xzf /backup/db-backup.tar.gz -C /
```
