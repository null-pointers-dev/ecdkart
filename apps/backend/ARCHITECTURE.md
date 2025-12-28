# NestJS Backend Project Structure

## Overview

This NestJS backend project has been created with:
- ✅ Latest NestJS versions (10.x)
- ✅ Vitest with two configurations (unit/integration & e2e)
- ✅ No ESLint/Prettier (using Biome from root)
- ✅ TypeScript with path aliases
- ✅ Reflect-metadata for NestJS decorators
- ✅ Code generation support via @nestjs/cli

## Generated Files

### Configuration Files

| File | Purpose |
|------|---------|
| `package.json` | Dependencies and scripts |
| `tsconfig.json` | TypeScript configuration extending root tsconfig |
| `nest-cli.json` | NestJS CLI configuration |
| `.npmrc` | pnpm configuration (shamefully-hoist enabled) |
| `.gitignore` | Git ignore rules |
| `.env.example` | Environment variables template |

### Test Configuration Files

| File | Purpose |
|------|---------|
| `vitest.config.ts` | Unit & integration test configuration |
| `vitest.e2e.config.ts` | E2E test configuration |
| `vitest.setup.ts` | Global setup (imports reflect-metadata) |

### Documentation

| File | Purpose |
|------|---------|
| `README.md` | Project overview and quick start |
| `SETUP.md` | Detailed setup and development guide |
| `VITEST.md` | Vitest configuration details and examples |
| `ARCHITECTURE.md` | This file - project structure overview |

### Source Code

#### Entry Point
- `src/main.ts` - Application bootstrap

#### Core Modules
- `src/app.module.ts` - Root application module
- `src/app.controller.ts` - Root controller with GET / endpoint
- `src/app.service.ts` - Root service with getHello() method

#### Tests
- `src/app.controller.spec.ts` - Controller unit tests
- `src/app.service.spec.ts` - Service unit tests
- `src/app.e2e.ts` - E2E tests

## NPM Scripts

```json
{
  "build": "nest build",              // Build for production
  "start": "nest start",              // Run production build
  "start:dev": "nest start --watch",  // Development with hot reload
  "start:debug": "nest start --debug --watch",
  "start:prod": "node dist/main",     // Run production
  "test": "vitest run",               // Run unit/integration tests once
  "test:watch": "vitest",             // Watch mode for tests
  "test:cov": "vitest run --coverage",// Tests with coverage report
  "test:e2e": "vitest run --config vitest.e2e.config.ts"
}
```

## Dependencies

### Production Dependencies
- `@nestjs/common` - Core NestJS library
- `@nestjs/core` - NestJS core module
- `@nestjs/platform-express` - Express HTTP adapter
- `rxjs` - Reactive Extensions
- `reflect-metadata` - Metadata reflection (required for NestJS)

### Development Dependencies
- `@nestjs/cli` - Code generation and scaffolding
- `@nestjs/schematics` - Schematics for code generation
- `@nestjs/testing` - Testing utilities for NestJS
- `vitest` - Unit testing framework
- `@vitest/coverage-v8` - Code coverage provider
- `typescript` - TypeScript compiler
- `@types/node` - Node.js type definitions

## Testing Strategy

### Unit & Integration Tests
- **Config**: `vitest.config.ts`
- **Pattern**: `**/*.spec.ts` or `**/*.test.ts`
- **Command**: `pnpm test`
- **Watch Mode**: `pnpm test:watch`
- **Coverage**: `pnpm test:cov`

### E2E Tests
- **Config**: `vitest.e2e.config.ts`
- **Pattern**: `**/*.e2e.ts`
- **Command**: `pnpm test:e2e`
- **Timeout**: 30 seconds

## Path Aliases

The project is configured with TypeScript path aliases:
- `@/*` → `src/*`

This allows imports like:
```typescript
import { AppService } from '@/app.service';
import type { SomeType } from '@/types/some.type';
```

## Code Formatting

Code formatting and linting are handled by **Biome** from the root monorepo:
- No local ESLint configuration
- No local Prettier configuration
- Run `pnpm format` from the root to format all files

## Getting Started

1. **Install dependencies** (from monorepo root):
   ```bash
   pnpm install
   ```

2. **Start development server**:
   ```bash
   cd apps/backend
   pnpm start:dev
   ```

3. **Run tests**:
   ```bash
   pnpm test
   ```

4. **Build for production**:
   ```bash
   pnpm build
   ```

## Next Steps

1. Create API modules and controllers
2. Add service layers and business logic
3. Write unit tests for services
4. Write integration tests for modules
5. Write E2E tests for API endpoints
6. Add environment-specific configurations
7. Implement authentication/authorization if needed
8. Add database integration (TypeORM, Prisma, etc.)

For more details, see:
- `SETUP.md` - Development setup guide
- `VITEST.md` - Testing configuration details
- NestJS Documentation: https://docs.nestjs.com
- Vitest Documentation: https://vitest.dev
