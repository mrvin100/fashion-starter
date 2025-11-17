#!/bin/sh
# ============================
# Storefront entrypoint
# ============================

# Ensure .env exists
if [ ! -f /app/.env ]; then
  echo "Creating .env from template..."
  cp /app/.env.template /app/.env
fi

# Start Next.js server
yarn start
