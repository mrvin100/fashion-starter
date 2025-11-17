#!/bin/bash

# Simplified production setup script for Fashion Starter
echo "🚀 Setting up Fashion Starter for production deployment..."

# Load main .env file
if [ -f ".env" ]; then
    source .env
    echo "✅ Loaded main .env file"
else
    echo "❌ Main .env file not found! Please create it first."
    exit 1
fi

echo "📋 Simplified Setup Process:"
echo "1. 🏗️  Build and start all services (auto-initialization included)"
echo "2. ⏳ Wait for all services to be ready"
echo "3. 🔑 Get API keys for final configuration"
echo ""

# Step 1: Build and start services (Medusa will auto-initialize)
echo "🏗️  Building and starting all services..."
echo "📦 Medusa will automatically initialize database, run migrations, seed data, and create admin user"
docker-compose up -d --build

# Step 2: Wait for services to be ready
echo "⏳ Waiting for all services to be ready..."
echo "This may take a few minutes for the first run..."

# Wait for infrastructure services first
echo "Waiting for infrastructure services..."
until docker exec postgres-db pg_isready -U ${POSTGRES_USER:-postgres} > /dev/null 2>&1; do
  echo "⏰ Postgres starting..."
  sleep 3
done

until docker exec redis-cache redis-cli ping > /dev/null 2>&1; do
  echo "⏰ Redis starting..."
  sleep 2
done

until curl -f http://localhost:${MINIO_API_PORT:-9090}/minio/health/live > /dev/null 2>&1; do
  echo "⏰ MinIO starting..."
  sleep 2
done

until curl -f http://localhost:${MEILISEARCH_PORT:-7700}/health > /dev/null 2>&1; do
  echo "⏰ MeiliSearch starting..."
  sleep 2
done

echo "✅ Infrastructure services ready!"

# Wait for Medusa (includes initialization time)
echo "⏳ Waiting for Medusa to complete initialization..."
echo "📦 This includes database migration, seeding, and admin user creation..."
until curl -f http://localhost:${MEDUSA_PORT:-9000}/health > /dev/null 2>&1; do
  echo "⏰ Medusa initializing..."
  sleep 5
done

echo "✅ Medusa ready!"

# Wait for Storefront
echo "⏳ Waiting for Storefront..."
until curl -f http://localhost:${STOREFRONT_PORT:-8000} > /dev/null 2>&1; do
  echo "⏰ Storefront starting..."
  sleep 3
done

echo "✅ All services are ready!"

echo ""
echo "🎉 Production setup completed successfully!"
echo ""
echo "📋 Access your application:"
echo "🛍️  Storefront: http://localhost:${STOREFRONT_PORT:-8000}"
echo "⚙️  Medusa Admin: http://localhost:${MEDUSA_PORT:-9000}/app"
echo "🔍 MeiliSearch: http://localhost:${MEILISEARCH_PORT:-7700}"
echo "📦 MinIO Console: http://localhost:${MINIO_CONSOLE_PORT:-9001}"
echo ""
echo "🔐 Default Admin Credentials:"
echo "Email: admin@medusa.local"
echo "Password: supersecret"
echo ""
echo "📋 Final configuration steps:"
echo "1. Login to Medusa Admin: http://localhost:${MEDUSA_PORT:-9000}/app"
echo "2. Go to Settings > Publishable API Keys and copy the key"
echo "3. Update NEXT_PUBLIC_MEDUSA_PUBLISHABLE_KEY in .env file"
echo "4. Get MeiliSearch API key:"
echo "   curl -H 'Authorization: Bearer ${MEILISEARCH_MASTER_KEY:-yoursecretmasterkey}' http://localhost:${MEILISEARCH_PORT:-7700}/keys"
echo "5. Update NEXT_PUBLIC_SEARCH_API_KEY in .env file"
echo "6. Restart storefront: docker-compose restart storefront"
echo ""
echo "🔧 Useful commands:"
echo "• View logs: docker-compose logs -f [service-name]"
echo "• Restart service: docker-compose restart [service-name]"
echo "• Stop all: docker-compose down"
echo "• Reset all data: docker-compose down -v && docker-compose up -d --build"
