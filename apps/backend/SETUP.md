# NestJS Backend Setup Guide

This is a NestJS backend project within a monorepo workspace. It uses Vitest for testing with separate configurations for unit/integration and E2E tests.

## Installation

First, install dependencies from the root of the monorepo:

```bash
pnpm install
```

## Development

```bash
# Start the development server (with hot reload)
pnpm start:dev

# Start in debug mode
pnpm start:debug

# Build for production
pnpm build

# Run production build
pnpm start:prod
```

## Testing

The project is configured with **Vitest** with two separate configurations:

### Main Config (Unit & Integration Tests)
- **Config file**: `vitest.config.ts`
- **Command**: `pnpm test` or `pnpm test:watch`
- **Test files**: `**/*.spec.ts` and `**/*.test.ts`
- **Coverage**: `pnpm test:cov`

### E2E Config
- **Config file**: `vitest.e2e.config.ts`
- **Command**: `pnpm test:e2e`
- **Test files**: `**/*.e2e.ts`
- **Timeout**: 30 seconds

### Example Test Structure

**Unit/Integration Test** (`src/app.service.spec.ts`):
```typescript
import { Test, TestingModule } from '@nestjs/testing';
import { AppService } from './app.service';
import { describe, it, expect, beforeEach } from 'vitest';

describe('AppService', () => {
	let service: AppService;

	beforeEach(async () => {
		const module: TestingModule = await Test.createTestingModule({
			providers: [AppService],
		}).compile();

		service = module.get<AppService>(AppService);
	});

	it('should return "Hello from backend!"', () => {
		expect(service.getHello()).toBe('Hello from backend!');
	});
});
```

**E2E Test** (`src/app.e2e.ts`):
```typescript
import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication } from '@nestjs/common';
import { AppModule } from './app.module';
import { describe, it, expect, beforeAll, afterAll } from 'vitest';

describe('App E2E', () => {
	let app: INestApplication;

	beforeAll(async () => {
		const moduleFixture: TestingModule = await Test.createTestingModule({
			imports: [AppModule],
		}).compile();

		app = moduleFixture.createNestApplication();
		await app.init();
	});

	afterAll(async () => {
		await app.close();
	});

	it('/ (GET)', async () => {
		const response = await app.get('/');
		expect(response).toBeDefined();
	});
});
```

## Project Structure

```
src/
├── app.module.ts           # Root module
├── app.controller.ts       # Root controller
├── app.service.ts          # Root service
├── app.controller.spec.ts  # Unit tests
├── app.service.spec.ts     # Unit tests
├── app.e2e.ts              # E2E tests
└── main.ts                 # Application entry point
```

## Configuration Files

### TypeScript
- `tsconfig.json` - Extends the root tsconfig with NestJS-specific settings

### Vitest
- `vitest.config.ts` - Unit/integration test configuration
- `vitest.e2e.config.ts` - E2E test configuration
- `vitest.setup.ts` - Global setup (imports reflect-metadata)

### NestJS CLI
- `nest-cli.json` - NestJS CLI configuration

### Package Management
- `.npmrc` - pnpm configuration with shamefully-hoist enabled

## Code Formatting

This project uses **Biome** from the root of the monorepo for formatting and linting. There is no local ESLint or Prettier configuration.

Run formatting from the root:
```bash
pnpm format
```

## Dependencies

- **@nestjs/common** - Core NestJS library
- **@nestjs/core** - NestJS core module
- **@nestjs/platform-express** - Express adapter for NestJS
- **@nestjs/testing** - Testing utilities for NestJS
- **@nestjs/cli** - NestJS CLI tool
- **@nestjs/schematics** - Schematics for code generation
- **rxjs** - Reactive Extensions library
- **reflect-metadata** - Metadata reflection library (required for decorators)
- **vitest** - Unit testing framework
- **@vitest/coverage-v8** - Code coverage provider
- **typescript** - TypeScript compiler
