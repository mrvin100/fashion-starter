#!/bin/sh
set -e

echo "🚀 Starting Medusa Server..."

# 1. Wait for database to be ready
echo "⏳ Waiting for database to be ready..."
until pg_isready -h postgres -U ${POSTGRES_USER:-postgres} -d ${POSTGRES_DB:-medusa}; do
  echo "⏰ Waiting for postgres..."
  sleep 2
done

# 2. Wait for Redis to be ready
echo "⏳ Waiting for Redis to be ready..."
until redis-cli -h redis ping | grep -q "PONG"; do
  echo "⏰ Waiting for redis..."
  sleep 2
done

# 3. Run migrations & create admin user (only once)
FLAG_FILE="/app/.medusa_initialized"
if [ ! -f "$FLAG_FILE" ]; then
  echo "📦 Running migrations..."
  yarn medusa db:migrate

  echo "🌱 Seeding database..."
  yarn seed

  echo "👤 Creating admin user..."
  yarn medusa user -e admin@medusa.local -p supersecret || echo "⚠️  Admin user already exists or failed"

  touch "$FLAG_FILE"
  echo "✅ Medusa initialization completed!"
else
  echo "✅ Migrations & admin user creation already done, skipping..."
fi

# 4. Start Medusa server
echo "🎯 Starting Medusa server..."
exec yarn start