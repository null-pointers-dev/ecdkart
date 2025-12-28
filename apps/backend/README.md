# Backend

NestJS backend application for ecdkart.

## Installation

```bash
pnpm install
```

## Development

```bash
# Start in watch mode
pnpm start:dev

# Start in debug mode
pnpm start:debug

# Build the application
pnpm build

# Run the application
pnpm start:prod
```

## Testing

```bash
# Run unit and integration tests
pnpm test

# Run tests in watch mode
pnpm test:watch

# Generate coverage report
pnpm test:cov

# Run E2E tests
pnpm test:e2e
```

## Project Structure

- `src/main.ts` - Application entry point
- `src/**/*.spec.ts` - Unit and integration tests
- `src/**/*.e2e.ts` - E2E tests

## Configuration

- `tsconfig.json` - TypeScript configuration
- `vitest.config.ts` - Vitest unit/integration test configuration
- `vitest.e2e.config.ts` - Vitest E2E test configuration

Code formatting is handled by Biome at the root of the monorepo.
