# ecdkart (monorepo)

This repository is a pnpm + Turborepo monorepo scaffold for the `ecdkart` project.

## 📋 Requirements

- **Node.js**: `>= 22.12.0` (Latest LTS)
- **pnpm**: `>= 10.0.0`
- **Docker**: `>= 20.10` (optional, for containerized development)

### Quick Version Check

```bash
./scripts/check-env.sh
```

Or use [nvm](https://github.com/nvm-sh/nvm) / [fnm](https://github.com/Schniz/fnm):

```bash
# Using nvm
nvm use

# Using fnm
fnm use
```

See [NODE_VERSION.md](./NODE_VERSION.md) for detailed version management instructions.

## ✨ Key features:

- **Node.js 22.12.0** enforced across all environments
- pnpm workspaces (apps/\*, packages/\*)
- Turborepo for fast task orchestration and caching (`turbo.json`)
- Biome as the formatter + linter (replaces ESLint + Prettier)
- Husky v9 pre-commit hooks with lint-staged
- GitHub Actions CI that installs and runs checks/build
- **Docker support** for backend (see `apps/backend/infra/`)

## 🚀 Quick start

### 1. Check your environment

```bash
./scripts/check-env.sh
```

### 2. Install dependencies

   ```bash
   pnpm install
   ```

### 3. Setup Git hooks (optional, for Git users)

   ```bash
   ./scripts/setup-husky.sh
   # Or manually:
   git init
   git config core.hooksPath .husky
   ```

### 4. Run scripts

- `pnpm dev` # run turbo dev
- `pnpm build` # run turbo build
- `pnpm lint` # run turbo lint (runs `biome lint` in packages/apps)
- `pnpm format` # format the repository with Biome

## 🐳 Docker Development

Backend includes full Docker support with separate database and application containers.

```bash
cd apps/backend/infra
./docker.sh up
```

See [apps/backend/infra/README.md](./apps/backend/infra/README.md) for details.

## 📦 Adding packages/apps

Create folders under `apps/` and `packages/`. Each package should have its own `package.json` and (optionally) `tsconfig.json`. Turborepo and pnpm will pick them up automatically.

If you want me to scaffold a specific app or package, tell me which tech stack (Next.js, React, Node, etc.) and I’ll add it.
