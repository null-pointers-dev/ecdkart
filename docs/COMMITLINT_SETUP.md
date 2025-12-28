# Commitlint Setup

This project uses **commitlint** to enforce conventional commit messages. Commitlint validates commit messages against a set of rules before allowing them to be committed.

## Installation

Commitlint and the conventional config are already installed as dev dependencies:
- `@commitlint/cli` - The commitlint command line tool
- `@commitlint/config-conventional` - Conventional commits configuration

## Configuration

The commitlint configuration is defined in `commitlint.config.js` at the workspace root.

### Conventional Commit Format

Commits must follow the conventional commit format:

```
<type>(<optional scope>): <subject>

<optional body>

<optional footer>
```

### Allowed Commit Types

- **feat**: A new feature
- **fix**: A bug fix
- **docs**: Documentation only changes
- **style**: Changes that don't affect code meaning (formatting, whitespace, etc.)
- **refactor**: Code change that neither fixes a bug nor adds a feature
- **perf**: Code change that improves performance
- **test**: Adding or updating tests
- **ci**: Changes to CI/CD configuration
- **chore**: Changes to build process, dependencies, etc.
- **revert**: Revert a previous commit

### Rules

The following rules are enforced:

- Type must be lowercase
- Type cannot be empty
- Subject cannot be empty
- Subject must not end with a period (.)
- Subject case must be lowercase
- Body must have a leading blank line (if present)
- Footer must have a leading blank line (if present)

## Usage

### Writing a Good Commit Message

**Valid examples:**
```
feat: add user authentication
fix: resolve login button alignment issue
docs: update installation instructions
test: add tests for user service
```

**Invalid examples:**
```
Add user authentication          ❌ Missing type
FEAT: add user authentication    ❌ Type must be lowercase
feat: add user authentication.   ❌ Subject must not end with period
```

### Commit Message with Body

```
feat: add user authentication

Implement JWT-based authentication system
with support for login, logout, and token refresh.

Closes #123
```

## Git Hooks

Commitlint is automatically triggered via the `commit-msg` git hook (located in `.husky/commit-msg`). This hook runs before allowing a commit to be created.

If your commit message doesn't follow the conventional format, you'll see an error like:

```
⧗   input: invalid commit message
✖   subject may not be empty [subject-empty]
✖   type may not be empty [type-empty]

✖   found 2 problems, 0 warnings
```

Simply rewrite your commit message following the conventional format and try again.

## Manual Validation

To manually check a commit message before committing:

```bash
echo "feat: my new feature" | pnpm exec commitlint
```

## References

- [Conventional Commits](https://www.conventionalcommits.org/)
- [Commitlint Documentation](https://commitlint.js.org/)
- [Angular Commit Guidelines](https://github.com/angular/angular/blob/master/CONTRIBUTING.md#commit)
