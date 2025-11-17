# --- Base Image -------------------------------------------------------------
FROM node:22-alpine AS base
WORKDIR /app

# --- Enable Corepack for Yarn 4 (Berry) ------------------------------------
RUN corepack enable
RUN corepack prepare yarn@4.7.0 --activate

# --- Install dependencies ---------------------------------------------------
FROM base AS deps
COPY package.json yarn.lock ./
RUN yarn install --immutable

# --- Build step -------------------------------------------------------------
FROM base AS builder
COPY --from=deps /app/node_modules ./node_modules
COPY . .
RUN yarn build

# --- Final production image -------------------------------------------------
FROM node:22-alpine AS runner
WORKDIR /app
ENV NODE_ENV=production

COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/dist ./dist
COPY package.json ./

EXPOSE 9000

CMD ["yarn", "start"]
