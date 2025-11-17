# ---------- CONFIG ----------
PROJECT_NAME=fashion-starter
DOCKER=docker compose

# ---------- PRODUCTION SETUP ----------

# Complete production setup
setup:
	@echo "🚀 Starting production setup..."
	@chmod +x setup-env.sh
	@./setup-env.sh

# Quick start (build and run all services)
up:
	@echo "🏗️  Building and starting all services..."
	$(DOCKER) up -d --build

# Build all containers
build:
	@echo "🔨 Building all containers..."
	$(DOCKER) build --no-cache

# ---------- SERVICE MANAGEMENT ----------

# Stop all services
down:
	$(DOCKER) down

# Restart all services
restart:
	$(DOCKER) restart

# Restart specific service
restart-medusa:
	$(DOCKER) restart medusa-server

restart-storefront:
	$(DOCKER) restart storefront

restart-postgres:
	$(DOCKER) restart postgres-db

restart-redis:
	$(DOCKER) restart redis-cache

restart-minio:
	$(DOCKER) restart minio-storage

restart-meilisearch:
	$(DOCKER) restart meilisearch

# ---------- LOGS ----------

# View all logs
logs:
	$(DOCKER) logs -f

# Service-specific logs
logs-medusa:
	$(DOCKER) logs -f medusa-server

logs-storefront:
	$(DOCKER) logs -f storefront

logs-postgres:
	$(DOCKER) logs -f postgres-db

logs-redis:
	$(DOCKER) logs -f redis-cache

logs-minio:
	$(DOCKER) logs -f minio-storage

logs-meilisearch:
	$(DOCKER) logs -f meilisearch

# ---------- UTILITIES ----------

# Get MeiliSearch API key
get-search-key:
	@echo "🔑 Getting MeiliSearch API key..."
	@curl -H "Authorization: Bearer yoursecretmasterkey" http://localhost:7700/keys

# Check service health
health:
	@echo "🏥 Checking service health..."
	@echo "Postgres:" && curl -f http://localhost:5432 > /dev/null 2>&1 && echo "✅ OK" || echo "❌ DOWN"
	@echo "Redis:" && docker exec redis-cache redis-cli ping > /dev/null 2>&1 && echo "✅ OK" || echo "❌ DOWN"
	@echo "MinIO:" && curl -f http://localhost:9090/minio/health/live > /dev/null 2>&1 && echo "✅ OK" || echo "❌ DOWN"
	@echo "MeiliSearch:" && curl -f http://localhost:7700/health > /dev/null 2>&1 && echo "✅ OK" || echo "❌ DOWN"
	@echo "Medusa:" && curl -f http://localhost:9000/health > /dev/null 2>&1 && echo "✅ OK" || echo "❌ DOWN"
	@echo "Storefront:" && curl -f http://localhost:8000 > /dev/null 2>&1 && echo "✅ OK" || echo "❌ DOWN"

# Show service URLs
urls:
	@echo "📋 Service URLs:"
	@echo "🛍️  Storefront: http://localhost:8000"
	@echo "⚙️  Medusa Admin: http://localhost:9000/app"
	@echo "🔍 MeiliSearch: http://localhost:7700"
	@echo "📦 MinIO Console: http://localhost:9001"

# Reset everything (dangerous - removes all data)
reset:
	@echo "⚠️  This will remove ALL data. Are you sure? [y/N]" && read ans && [ $${ans:-N} = y ]
	$(DOCKER) down -v
	$(DOCKER) up -d --build

# ---------- SHORTCUTS ----------
install: setup
start: up
deploy: build up
