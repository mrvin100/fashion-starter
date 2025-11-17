#!/bin/sh
# ============================
# Medusa entrypoint
# ============================

# 1. Ensure .env exists
if [ ! -f /app/.env ]; then
  echo "Creating .env from template..."
  cp /app/.env.template /app/.env
fi

# 2. Run migrations & create admin user (only once)
FLAG_FILE="/app/.medusa_initialized"
if [ ! -f "$FLAG_FILE" ]; then
  echo "Running migrations..."
  yarn medusa db:migrate

  echo "Seeding database..."
  yarn seed

  echo "Creating admin user..."
  yarn medusa user -e admin@medusa.local -p supersecret || echo "Admin user already exists"

  touch "$FLAG_FILE"
else
  echo "Migrations & admin user creation already done, skipping..."
fi

# 3. Start Medusa server
echo "Starting Medusa server..."
yarn start
