# Vitest Configuration Details

This project uses **Vitest** with two separate configurations for different testing scenarios.

## Main Configuration (`vitest.config.ts`)

Used for **unit and integration tests**.

### Features
- **Environment**: Node.js
- **Globals**: Enabled (no need to import `describe`, `it`, `expect`, etc.)
- **Include Pattern**: `src/**/*.{test,spec}.ts`
- **Exclude Pattern**: `node_modules`, `dist`, `**/*.e2e.ts`
- **Coverage Provider**: V8
- **Coverage Reporters**: text, json, html, lcov
- **Path Aliases**: `@/*` → `src/*`
- **Setup Files**: `vitest.setup.ts` (imports reflect-metadata)

### Running Tests
```bash
# Run once
pnpm test

# Watch mode
pnpm test:watch

# With coverage
pnpm test:cov
```

## E2E Configuration (`vitest.e2e.config.ts`)

Used for **end-to-end tests**.

### Features
- **Environment**: Node.js
- **Globals**: Enabled
- **Include Pattern**: `src/**/*.e2e.ts`
- **Test Timeout**: 30 seconds
- **Path Aliases**: `@/*` → `src/*`
- **Setup Files**: `vitest.setup.ts` (imports reflect-metadata)

### Running E2E Tests
```bash
pnpm test:e2e
```

## Setup File (`vitest.setup.ts`)

Global setup file that runs before all tests:
- Imports `reflect-metadata` (required for NestJS decorators)
- Can be extended with additional global configurations

## Coverage Configuration

Coverage is only enabled in the main `vitest.config.ts`. When running coverage:

```bash
pnpm test:cov
```

Coverage reports are generated in:
- `text` format (terminal output)
- `json` format (for CI/CD integration)
- `html` format (browsable report)
- `lcov` format (for tools like Codecov)

Covered files are all `src/**/*.ts` except:
- `node_modules/`
- `dist/`
- `**/*.e2e.ts`

## Tips for Writing Tests

### Unit Test
```typescript
import { describe, it, expect, beforeEach } from 'vitest';

describe('MyService', () => {
	let service: MyService;

	beforeEach(() => {
		service = new MyService();
	});

	it('should do something', () => {
		expect(service.method()).toBe('expected');
	});
});
```

### Integration Test
```typescript
import { Test, TestingModule } from '@nestjs/testing';
import { describe, it, expect, beforeEach } from 'vitest';

describe('MyModule', () => {
	let module: TestingModule;

	beforeEach(async () => {
		module = await Test.createTestingModule({
			imports: [MyModule],
		}).compile();
	});

	it('should have all providers', () => {
		expect(module.get(MyService)).toBeDefined();
	});
});
```

### E2E Test
```typescript
import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication } from '@nestjs/common';
import { describe, it, expect, beforeAll, afterAll } from 'vitest';

describe('API E2E', () => {
	let app: INestApplication;

	beforeAll(async () => {
		const module = await Test.createTestingModule({
			imports: [AppModule],
		}).compile();
		app = module.createNestApplication();
		await app.init();
	});

	afterAll(async () => {
		await app.close();
	});

	it('GET / should return 200', async () => {
		const response = await app.get('/');
		expect(response.status).toBe(200);
	});
});
```
