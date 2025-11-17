# --- Simplified Dockerfile ---------------------------------------------------
FROM node:22-alpine
WORKDIR /app

# Install system dependencies and setup Yarn 4
RUN apk add --no-cache curl && \
    corepack enable && \
    corepack prepare yarn@4.7.0 --activate

# Copy package files
COPY package.json yarn.lock .yarnrc.yml ./

# Install dependencies
RUN yarn install --immutable

# Copy source code
COPY . .

# Create dummy .env.local to prevent build-time API calls
RUN echo "NEXT_PUBLIC_MEDUSA_BACKEND_URL=http://localhost:9000" > .env.local && \
    echo "NEXT_PUBLIC_BASE_URL=http://localhost:8000" >> .env.local && \
    echo "NEXT_PUBLIC_SEARCH_ENDPOINT=http://localhost:7700" >> .env.local && \
    echo "NEXT_PUBLIC_FEATURE_SEARCH_ENABLED=false" >> .env.local && \
    echo "SKIP_ENV_VALIDATION=true" >> .env.local

# Build the application
RUN yarn build

# Next.js port
EXPOSE 8000

# Use the default command
CMD ["yarn", "start"]