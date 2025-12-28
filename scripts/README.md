# Scripts Directory

This directory contains utility scripts for the monorepo.

## Available Scripts

### 🔍 `check-env.sh`
**Purpose**: Manual environment checker  
**When to use**: Run anytime to verify your development environment

Checks:
- ✅ Node.js version (>= 22.12.0)
- ✅ pnpm version (>= 10.0.0)
- ✅ Docker version (optional)

```bash
./scripts/check-env.sh
```

**Output**:
```
🔍 Checking development environment versions...

Node.js: ✅ v22.18.0 (required: >=22.12.0)
pnpm:    ✅ v10.26.2 (required: >=10.26.2)
Docker:  ✅ v28.4.0

🎉 All required tools are correctly installed!
```

---

### ⚙️ `check-versions.js`
**Purpose**: Pre-install version validator  
**When to use**: Automatically runs before `pnpm install`

**You don't need to run this manually!** It's called automatically via the `preinstall` script in `package.json`.

Checks:
- ✅ Node.js version matches `engines.node`
- ✅ pnpm version matches `engines.pnpm`

If versions don't match, install is blocked with helpful error messages.

---

### 🎣 `setup-husky.sh`
**Purpose**: Initialize Git hooks  
**When to use**: First time setup or after cloning the repo

```bash
./scripts/setup-husky.sh
```

This script:
1. Initializes Git (if not already done)
2. Configures Git to use `.husky` for hooks
3. Makes pre-commit hook executable
4. Displays setup confirmation

---

## Scripts vs Root Files

### ✅ Keep in `scripts/`:
- Utility scripts that users run manually
- Setup/installation scripts
- Automation scripts
- Any Node.js scripts used by package.json

### ❌ Don't put in `scripts/`:
- Version control files (`.nvmrc`, `.node-version`)
- Configuration files (`biome.json`, `package.json`)
- Documentation files (`README.md`, `*.md`)

---

## Adding New Scripts

When adding a new script:

1. **Create the file** in `scripts/`
2. **Add a shebang** line:
   ```bash
   #!/bin/bash
   # or
   #!/usr/bin/env node
   ```
3. **Add a description** at the top
4. **Make it executable**:
   ```bash
   chmod +x scripts/your-script.sh
   ```
5. **Update this README** with usage instructions
6. **Document in main README** if it's user-facing

---

## Script Naming Convention

- Use kebab-case: `check-env.sh`, `setup-husky.sh`
- Use descriptive names: `check-env` not `check`
- Add extension: `.sh` for bash, `.js` for Node.js
- Avoid generic names: `test.sh`, `run.sh`

---

## Relationship with package.json Scripts

Some scripts here are called from `package.json`:

```json
{
  "scripts": {
    "preinstall": "node scripts/check-versions.js"
  }
}
```

This is the recommended pattern for:
- Complex scripts (more than 1-2 commands)
- Scripts that need to be shared/reused
- Scripts that need version control
