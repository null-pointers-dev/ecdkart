# Husky Configuration (v9+)

This project uses [Husky v9](https://typicode.github.io/husky/) for Git hooks.

## What Changed in Husky v9

### ❌ Old Way (Deprecated)
```json
{
  "scripts": {
    "prepare": "husky install"  // ⚠️ DEPRECATED
  }
}
```

### ✅ New Way (v9+)
Husky v9+ automatically works without `husky install`. Just use:

```bash
pnpm exec husky init  # One-time setup
```

## Setup

### First Time Setup

1. **Initialize Git** (if not already done):
   ```bash
   git init
   ```

2. **Initialize Husky**:
   ```bash
   pnpm exec husky init
   ```

   This creates:
   - `.husky/` directory
   - `.husky/pre-commit` hook

3. **Verify it works**:
   ```bash
   git add .
   git commit -m "test"
   # Should run lint-staged automatically
   ```

## Git Hooks

### pre-commit
Runs before every commit to:
- Format code with Biome
- Lint and fix issues with Biome
- Only on staged files (via lint-staged)

**File**: `.husky/pre-commit`
```bash
#!/usr/bin/env sh
pnpm exec lint-staged
```

## lint-staged Configuration

Configured in `package.json`:

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

This means:
- On commit, only **staged files** matching the pattern are processed
- Biome formats them
- Biome lints and auto-fixes issues
- Files are automatically re-staged after fixes

## How It Works

1. You stage files: `git add file.ts`
2. You commit: `git commit -m "message"`
3. Husky triggers pre-commit hook
4. lint-staged runs on staged files only
5. Biome formats and lints those files
6. If successful, commit proceeds
7. If errors, commit is blocked

## Bypassing Hooks (Use Sparingly)

```bash
# Skip hooks for one commit
git commit -m "message" --no-verify

# Or use shorthand
git commit -m "message" -n
```

⚠️ **Warning**: Only use this if absolutely necessary!

## Troubleshooting

### Hook not running

```bash
# Check if .husky/pre-commit is executable
ls -la .husky/pre-commit

# Make it executable if needed
chmod +x .husky/pre-commit
```

### "command not found" errors

Make sure you're using pnpm:
```bash
# ✅ Correct
pnpm install

# ❌ Wrong
npm install
```

### Hook runs on all files (not just staged)

Check your lint-staged config in `package.json`. It should use lint-staged, not run commands directly.

### Husky not found

```bash
# Reinstall dependencies
pnpm install
```

## CI/CD

Husky hooks only run locally, not in CI/CD. For CI/CD, use direct commands:

```yaml
# GitHub Actions example
- name: Lint and Format
  run: |
    pnpm biome check --write .
```

## Manual Setup (if init fails)

If `husky init` doesn't work:

1. Create `.husky/pre-commit`:
   ```bash
   mkdir -p .husky
   cat > .husky/pre-commit << 'EOF'
   #!/usr/bin/env sh
   pnpm exec lint-staged
   EOF
   chmod +x .husky/pre-commit
   ```

2. Configure Git to use .husky:
   ```bash
   git config core.hooksPath .husky
   ```

## Benefits

✅ **Automatic**: Runs on every commit
✅ **Fast**: Only processes staged files
✅ **Consistent**: Same formatting/linting for everyone
✅ **Fail-fast**: Catches issues before they reach CI/CD
✅ **Zero config**: Works automatically after setup

## Resources

- [Husky Documentation](https://typicode.github.io/husky/)
- [lint-staged Documentation](https://github.com/lint-staged/lint-staged)
- [Biome Documentation](https://biomejs.dev/)
