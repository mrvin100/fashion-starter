FROM node:22-alpine
WORKDIR /app

# Install system dependencies and setup Yarn 4
RUN apk add --no-cache curl postgresql-client redis && \
    corepack enable && \
    corepack prepare yarn@4.7.0 --activate

# Copy package files
COPY package.json yarn.lock .yarnrc.yml ./

# Install dependencies
RUN yarn install --immutable

# Copy source code
COPY . .

# Build the application
RUN yarn build

EXPOSE 9000

CMD ["yarn", "start"]