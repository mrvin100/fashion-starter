#!/bin/sh
set -e

echo "🚀 Starting Storefront..."

# Wait for Medusa to be ready
echo "⏳ Waiting for Medusa backend to be ready..."
until curl -f http://medusa:9000/health > /dev/null 2>&1; do
  echo "⏰ Waiting for medusa..."
  sleep 5
done

echo "✅ Medusa is ready, starting storefront..."
exec yarn start