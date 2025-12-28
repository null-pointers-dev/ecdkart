# Build stage
FROM node:22.12.0-alpine AS builder

# Install pnpm
RUN npm install -g pnpm@10.26.2

WORKDIR /app

# Copy root package files
COPY package.json pnpm-lock.yaml pnpm-workspace.yaml ./
COPY tsconfig.base.json ./

# Copy scripts folder (needed for preinstall hook)
COPY scripts ./scripts

# Copy backend package files
COPY apps/backend/package.json ./apps/backend/

# Install dependencies
RUN pnpm install --frozen-lockfile

# Copy backend source code
COPY apps/backend ./apps/backend

# Build the application
WORKDIR /app/apps/backend
RUN pnpm build

# Production stage
FROM node:22.12.0-alpine AS production

# Install pnpm
RUN npm install -g pnpm@10.26.2

WORKDIR /app

# Copy root package files
COPY package.json pnpm-lock.yaml pnpm-workspace.yaml ./
COPY tsconfig.base.json ./

# Copy scripts folder (needed for preinstall hook)
COPY scripts ./scripts

# Copy backend package.json
COPY apps/backend/package.json ./apps/backend/

# Install only production dependencies for backend workspace
# --ignore-scripts skips prepare hook (husky is devDependency)
RUN pnpm install --frozen-lockfile --filter=@ecdkart/backend --prod --ignore-scripts

# Copy built application from builder
COPY --from=builder /app/apps/backend/dist ./apps/backend/dist
COPY --from=builder /app/apps/backend/package.json ./apps/backend/package.json
COPY --from=builder /app/apps/backend/drizzle.config.ts ./apps/backend/

WORKDIR /app/apps/backend

# Expose the application port
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=40s \
  CMD node -e "require('http').get('http://localhost:3000/api', (r) => {process.exit(r.statusCode === 200 ? 0 : 1)})"

# Start the application
CMD ["pnpm", "prod"]
