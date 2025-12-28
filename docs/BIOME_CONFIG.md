# Biome Configuration

This monorepo uses [Biome](https://biomejs.dev/) v2.3.10 for linting and formatting with a hierarchical configuration structure.

## Structure

```
ecdkart/
├── biome.json (ROOT - base configuration)
├── apps/
│   ├── backend/
│   │   └── biome.json (extends from root)
│   ├── admin/
│   │   └── biome.json (extends from root)
│   └── mobile/
│       └── biome.json (extends from root)
└── packages/
    ├── ui/
    │   └── biome.json (extends from root)
    └── types/
        └── biome.json (extends from root)
```

## Root Configuration

The root `biome.json` contains:
- ✅ Recommended rules enabled
- ✅ Tab indentation (width: 4)
- ✅ Line width: 120
- ✅ Double quotes
- ✅ Semicolons always
- ✅ Trailing commas in arrays/objects
- ✅ Arrow parentheses always
- ✅ Strict unused variables/imports checking
- ⚠️ Explicit `any` warning

## App-Specific Configurations

### Backend (NestJS)
```json
{
  "$schema": "https://biomejs.dev/schemas/2.3.10/schema.json",
  "root": false,
  "extends": ["../../biome.json"],
  "linter": {
    "rules": {
      "suspicious": {
        "noConsole": "off"  // Allows console.log for server logs
      }
    }
  }
}
```

### Admin (Next.js Dashboard)
```json
{
  "$schema": "https://biomejs.dev/schemas/2.3.10/schema.json",
  "root": false,
  "extends": ["../../biome.json"],
  "linter": {
    "rules": {
      "a11y": {
        "useKeyWithClickEvents": "error",  // Enforce accessibility
        "useButtonType": "error"
      }
    }
  }
}
```

### Mobile (React Native)
```json
{
  "$schema": "https://biomejs.dev/schemas/2.3.10/schema.json",
  "root": false,
  "extends": ["../../biome.json"],
  "linter": {
    "rules": {
      "a11y": {
        "useKeyWithClickEvents": "off"  // Not applicable for mobile
      }
    }
  }
}
```

## Package-Specific Configurations

### UI Components
```json
{
  "$schema": "https://biomejs.dev/schemas/2.3.10/schema.json",
  "root": false,
  "extends": ["../../biome.json"],
  "linter": {
    "rules": {
      "a11y": {
        "useKeyWithClickEvents": "error",
        "useButtonType": "error"
      },
      "style": {
        "noDefaultExport": "error"  // Named exports only
      }
    }
  }
}
```

### Types Package
```json
{
  "$schema": "https://biomejs.dev/schemas/2.3.10/schema.json",
  "root": false,
  "extends": ["../../biome.json"],
  "linter": {
    "rules": {
      "style": {
        "noDefaultExport": "error"  // Named exports only
      },
      "suspicious": {
        "noExplicitAny": "error"  // Strict typing
      }
    }
  }
}
```

## How It Works

### Root and Nested Configurations

**Root Configuration** (`biome.json` at repository root):
- Sets base rules for the entire monorepo
- Contains all shared formatting and linting rules

**Nested Configurations** (in apps/ and packages/):
- Must have `"root": false` to indicate they're not root configs
- Use `"extends": ["../../biome.json"]` to inherit from root
- Can override or add specific rules for that app/package

### Extends: "../../biome.json"
The relative path `"../../biome.json"` means:
- Navigate up two directories from the nested config
- Load the root `biome.json` file
- Inherit all settings from it
- Apply local overrides specified in the nested config

### Configuration Hierarchy
1. Biome looks for the nearest `biome.json` in the current directory
2. If found and it has `"extends": ["//"]`, it loads the root config first
3. Then applies the local config overrides on top
4. All paths are resolved from the location of the config file

## Commands

```bash
# Check all files
pnpm biome check .

# Fix all auto-fixable issues
pnpm biome check --write .

# Format only
pnpm biome format --write .

# Lint only
pnpm biome lint .

# Check specific app
cd apps/backend
pnpm biome check .

# Check specific package
cd packages/ui
pnpm biome check .
```

## Scripts in package.json

Each app/package has these scripts:

```json
{
  "scripts": {
    "lint": "biome lint .",
    "format": "biome format .",
    "check": "biome check .",
    "format:write": "biome format --write ."
  }
}
```

## VS Code Integration

Install the official Biome extension:
```
code --install-extension biomejs.biome
```

### Settings
Add to `.vscode/settings.json`:

```json
{
  "editor.defaultFormatter": "biomejs.biome",
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "quickfix.biome": "explicit",
    "source.organizeImports.biome": "explicit"
  },
  "[javascript]": {
    "editor.defaultFormatter": "biomejs.biome"
  },
  "[typescript]": {
    "editor.defaultFormatter": "biomejs.biome"
  },
  "[json]": {
    "editor.defaultFormatter": "biomejs.biome"
  },
  "[jsonc]": {
    "editor.defaultFormatter": "biomejs.biome"
  }
}
```

## CI/CD Integration

### GitHub Actions

```yaml
name: Biome Check

on: [push, pull_request]

jobs:
  biome:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version-file: '.nvmrc'
      - uses: pnpm/action-setup@v2
        with:
          version: 10.26.2
      - run: pnpm install
      - run: pnpm biome ci .
```

### Pre-commit Hook

Using Husky (already configured):

```json
{
  "lint-staged": {
    "*.{js,jsx,ts,tsx,json,css,md}": [
      "biome format --write",
      "biome lint --fix"
    ]
  }
}
```

## Rules Philosophy

### Root Rules (Inherited by All)
- **Recommended**: All Biome recommended rules
- **Unused Code**: Error on unused variables/imports
- **Code Quality**: Warn on cognitive complexity
- **Type Safety**: Warn on explicit `any`
- **Consistency**: Enforce const, template literals

### App-Specific Overrides
- **Backend**: Allow console.log (for logging)
- **Admin**: Strict accessibility rules
- **Mobile**: Relaxed accessibility (mobile-specific patterns)

### Package-Specific Rules
- **UI**: Named exports, strict accessibility
- **Types**: Named exports, no `any` allowed

## Troubleshooting

### "Configuration schema version does not match"
Update Biome:
```bash
pnpm add -D -w @biomejs/biome@latest
```

### "Found unknown key"
Check that you're using correct Biome 2.x syntax:
- ❌ `files.ignore` → Use VCS ignore instead
- ❌ `organizeImports` → Part of formatter now
- ❌ `overrides.include` → Not needed in v2
- ✅ `extends: ["//"]` → Correct v2 syntax

### Config not being picked up
```bash
# Check which config Biome is using
pnpm biome explain <file-path>

# Force specific config
pnpm biome check --config-path=./biome.json .
```

## Benefits

✅ **Consistency**: Same rules across the entire monorepo
✅ **Flexibility**: Each app/package can override as needed
✅ **Performance**: Biome is written in Rust (100x faster than ESLint)
✅ **Simplicity**: One tool for formatting + linting
✅ **Type-aware**: Understands TypeScript natively
✅ **Monorepo-first**: Built-in support for workspaces

## Resources

- [Biome Documentation](https://biomejs.dev/)
- [Biome Big Projects Guide](https://biomejs.dev/guides/big-projects/)
- [Biome Rules Reference](https://biomejs.dev/linter/rules/)
- [Biome VS Code Extension](https://marketplace.visualstudio.com/items?itemName=biomejs.biome)
