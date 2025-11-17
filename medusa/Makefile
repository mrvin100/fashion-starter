# ---------- CONFIG ----------
PROJECT_NAME=odk
DOCKER=docker compose

# ---------- COMMANDS ---------

# Build all containers
build:
	$(DOCKER) build --no-cache

# Start full stack
up:
	$(DOCKER) up -d

# Stop containers
down:
	$(DOCKER) down

# See logs for medusa
logs-medusa:
	$(DOCKER) logs -f medusa

# See logs for storefront
logs-storefront:
	$(DOCKER) logs -f storefront

# See logs for meilisearch
logs-meilisearch:
	$(DOCKER) logs -f meilisearch

# See logs for minio
logs-minio:
	$(DOCKER) logs -f minio

# Rebuild medusa only
rebuild-medusa:
	$(DOCKER) build --no-cache medusa

# Rebuild storefront only
rebuild-storefront:
	$(DOCKER) build --no-cache storefront

# Rebuild Meilisearch only
rebuild-meilisearch:
	$(DOCKER) build --no-cache meilisearch

# Reset stack completely (dangerous)
reset:
	$(DOCKER) down -v
	$(DOCKER) up -d --build

# ---------- SHORTCUT ----------
deploy: build up
