# Node.js Version Management

This project enforces specific Node.js and pnpm versions to ensure consistency across development, CI/CD, and production environments.

## Required Versions

- **Node.js**: `22.12.0` (Latest LTS)
- **pnpm**: `10.26.2`

## Version Files

### `.nvmrc`
Used by [nvm](https://github.com/nvm-sh/nvm) (Node Version Manager) to automatically switch to the correct Node.js version.

```bash
# Install and use the correct Node.js version
nvm install
nvm use
```

### `.node-version`
Used by alternative Node.js version managers like:
- [fnm](https://github.com/Schniz/fnm) (Fast Node Manager)
- [nodenv](https://github.com/nodenv/nodenv)
- [asdf](https://github.com/asdf-vm/asdf)

```bash
# fnm will automatically use this version
fnm install
fnm use

# Or with auto-switching enabled
fnm env
```

### `.npmrc`
Contains `engine-strict=true` to enforce the versions specified in `package.json`.

### `package.json`
Contains the `engines` field that specifies required versions:

```json
{
  "engines": {
    "node": ">=22.12.0",
    "pnpm": ">=10.0.0"
  }
}
```

## Setup Instructions

### Option 1: Using nvm (Recommended for Mac/Linux)

```bash
# Install nvm (if not already installed)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

# Install the correct Node.js version
nvm install

# Use the version (automatic if you have nvm shell integration)
nvm use

# Verify
node --version  # Should show v22.12.0
```

### Option 2: Using fnm (Fast alternative)

```bash
# Install fnm (if not already installed)
# Mac/Linux:
curl -fsSL https://fnm.vercel.app/install | bash

# Windows (PowerShell):
winget install Schniz.fnm

# Install and use the correct version
fnm install
fnm use

# Enable auto-switching (recommended)
# Add to your shell profile (~/.bashrc, ~/.zshrc, etc.):
eval "$(fnm env --use-on-cd)"

# Verify
node --version  # Should show v22.12.0
```

### Option 3: Manual Installation

Download Node.js v22.12.0 from [nodejs.org](https://nodejs.org/) and install it manually.

## Installing pnpm

Once you have the correct Node.js version:

```bash
# Enable corepack (comes with Node.js)
corepack enable

# Install pnpm
corepack prepare pnpm@10.26.2 --activate

# Verify
pnpm --version  # Should show 10.26.2
```

## Enforcement

The project will **automatically fail** if you try to run `pnpm install` with the wrong Node.js or pnpm version, thanks to:

1. `engine-strict=true` in `.npmrc`
2. `engines` field in `package.json`

This ensures everyone on the team uses the same versions, preventing "works on my machine" issues.

## Docker

All Docker images use the exact same Node.js version:
- `Dockerfile.app`: `node:22.12.0-alpine`
- `Dockerfile.dev`: `node:22.12.0-alpine`

This guarantees consistency between local development and production deployments.

## CI/CD

Make sure your CI/CD pipeline uses the same versions:

### GitHub Actions Example

```yaml
- name: Setup Node.js
  uses: actions/setup-node@v4
  with:
    node-version-file: '.nvmrc'

- name: Setup pnpm
  uses: pnpm/action-setup@v2
  with:
    version: 10.26.2
```

### GitLab CI Example

```yaml
image: node:22.12.0-alpine

before_script:
  - corepack enable
  - corepack prepare pnpm@10.26.2 --activate
```

## Troubleshooting

### Error: "The engine 'node' is incompatible"

You're using the wrong Node.js version. Run:
```bash
nvm use
# or
fnm use
```

### Error: "The engine 'pnpm' is incompatible"

You're using the wrong pnpm version. Run:
```bash
corepack enable
corepack prepare pnpm@10.26.2 --activate
```

### I don't want to use nvm/fnm

That's fine! Just make sure you have Node.js v22.12.0 and pnpm v10.26.2 installed manually.

## Why These Versions?

- **Node.js 22.12.0**: Latest LTS (Long Term Support) version with the best stability and security
- **pnpm 10.26.2**: Latest stable pnpm with improved performance and disk space efficiency
- **Alpine Linux in Docker**: Minimal image size (~50MB vs ~1GB for full images)

## Updating Versions

When updating Node.js or pnpm versions, update these files:

1. `.nvmrc`
2. `.node-version`
3. `package.json` (`engines` field)
4. All `Dockerfile.*` files in `apps/backend/infra/`
5. CI/CD configuration files

This ensures consistency across all environments.
