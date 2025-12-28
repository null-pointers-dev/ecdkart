# Git Branching Strategy

This project follows a **GitHub Flow with Staging Branch** strategy for clean, consistent development workflow.

## Branch Structure

```
main (production)
  ↑
staging (pre-production/integration)
  ↑
feature/* (development)
```

## Branch Types

### 1. `main` - Production Branch
- **Purpose**: Production-ready code only
- **Protected**: ✅ Yes
- **Direct Pushes**: ❌ Not allowed
- **Merges From**: `staging` branch only (via PR)
- **Deployment**: Auto-deploys to production
- **Rules**:
  - Requires pull request reviews (minimum 1)
  - Requires status checks to pass
  - Requires branch to be up to date before merging
  - Administrators cannot bypass these rules

### 2. `staging` - Pre-Production/Integration Branch
- **Purpose**: Integration testing before production
- **Protected**: ✅ Yes
- **Direct Pushes**: ❌ Not allowed (except in emergencies)
- **Merges From**: Feature branches (via PR)
- **Merges To**: `main` branch (via PR after testing)
- **Deployment**: Auto-deploys to staging environment
- **Rules**:
  - Requires pull request reviews (minimum 1)
  - Requires status checks to pass
  - Can be force-pushed in emergencies (by admins only)

### 3. `feature/*` - Feature Development Branches
- **Purpose**: Individual feature development
- **Protected**: ❌ No
- **Direct Pushes**: ✅ Allowed
- **Merges From**: `staging` branch (to stay updated)
- **Merges To**: `staging` branch (via PR)
- **Naming Convention**: `feature/descriptive-name`
- **Examples**:
  - `feature/monorepo-setup`
  - `feature/user-authentication`
  - `feature/payment-integration`
  - `feature/docker-optimization`

### 4. `docs/*` - Documentation Updates
- **Purpose**: Documentation-only changes
- **Protected**: ❌ No
- **Direct Pushes**: ✅ Allowed
- **Merges From**: `staging` branch (to stay updated)
- **Merges To**: `staging` branch (via PR, fast review)
- **Naming Convention**: `docs/descriptive-name`
- **Examples**:
  - `docs/update-readme`
  - `docs/api-documentation`
  - `docs/setup-guide`
  - `docs/architecture-diagrams`
- **Special Notes**:
  - Fast-track review process (docs don't affect code)
  - Can be merged with 1 quick approval
  - No need for extensive testing

### 5. `hotfix/*` - Emergency Production Fixes (Optional)
- **Purpose**: Critical production bug fixes
- **Protected**: ❌ No
- **Branches From**: `main`
- **Merges To**: Both `main` AND `staging` (via separate PRs)
- **Naming Convention**: `hotfix/descriptive-name`
- **Examples**:
  - `hotfix/security-vulnerability`
  - `hotfix/payment-failure`
  - `hotfix/critical-crash`

## Workflow

### Starting New Feature

```bash
# Make sure you're on staging and it's up to date
git checkout staging
git pull origin staging

# Create feature branch
git checkout -b feature/your-feature-name

# Work on your feature...
git add .
git commit -m "feat: your changes"

# Push to GitHub
git push -u origin feature/your-feature-name

# Create PR on GitHub: feature/your-feature-name → staging
```

### Completing Feature

```bash
# On GitHub: Create Pull Request
# Base: staging ← Compare: feature/your-feature-name

# After review and approval:
# 1. Merge PR on GitHub
# 2. Delete feature branch on GitHub
# 3. Clean up locally
git checkout staging
git pull origin staging
git branch -d feature/your-feature-name
```

### Promoting to Production

```bash
# After testing on staging is complete and successful

# On GitHub: Create Pull Request
# Base: main ← Compare: staging

# After review and approval:
# 1. Merge PR on GitHub (creates production deployment)
# 2. Tag the release (recommended)
git checkout main
git pull origin main
git tag -a v1.0.0 -m "Release v1.0.0"
git push origin v1.0.0
```

### Emergency Hotfix

```bash
# Create hotfix from main
git checkout main
git pull origin main
git checkout -b hotfix/critical-issue

# Make the fix
git add .
git commit -m "fix: critical issue description"
git push -u origin hotfix/critical-issue

# Create TWO PRs on GitHub:
# 1. hotfix/critical-issue → main (urgent)
# 2. hotfix/critical-issue → staging (to keep in sync)

# After both are merged, delete hotfix branch
```

## Pull Request Guidelines

### Required Information
- **Title**: Clear, descriptive (follows conventional commits)
  - `feat:` for new features
  - `fix:` for bug fixes
  - `docs:` for documentation
  - `refactor:` for code refactoring
  - `test:` for adding tests
  - `chore:` for maintenance tasks

- **Description**: Must include:
  - What changes were made
  - Why the changes were necessary
  - How to test the changes
  - Screenshots (if UI changes)
  - Breaking changes (if any)

### Review Process
1. **Self-Review**: Author reviews their own code first
2. **Automated Checks**: All CI/CD checks must pass
   - Linting (Biome)
   - Type checking (TypeScript)
   - Unit tests
   - Build success
3. **Peer Review**: At least 1 approval required
4. **Testing**: Test on deployed staging environment
5. **Merge**: Squash and merge (keeps history clean)

## Branch Protection Rules

### `main` Branch
- ✅ Require pull request reviews before merging (1 reviewer)
- ✅ Require status checks to pass before merging
- ✅ Require branches to be up to date before merging
- ✅ Require conversation resolution before merging
- ✅ Do not allow bypassing the above settings
- ✅ Restrict who can push to matching branches (admins only for emergencies)
- ✅ Require linear history
- ❌ Allow force pushes: Never
- ❌ Allow deletions: Never

### `staging` Branch
- ✅ Require pull request reviews before merging (1 reviewer)
- ✅ Require status checks to pass before merging
- ✅ Require conversation resolution before merging
- ⚠️ Allow force pushes: Admins only (for emergency rollbacks)
- ❌ Allow deletions: Never

## Best Practices

### Commit Messages
Follow [Conventional Commits](https://www.conventionalcommits.org/):
```
<type>(<scope>): <subject>

<body>

<footer>
```

Examples:
```bash
feat(auth): add Google OAuth integration
fix(cart): resolve checkout calculation error
docs(readme): update installation instructions
refactor(api): extract user service logic
test(auth): add unit tests for login flow
chore(deps): update dependencies to latest versions
```

### Branch Naming
- Use lowercase with hyphens
- Be descriptive but concise
- Include ticket number if applicable

```bash
# Good
feature/user-profile-page
feature/JIRA-123-payment-gateway
hotfix/security-patch-xss

# Bad
feature/stuff
my-branch
test
```

### Keep Branches Updated
```bash
# Regularly sync your feature branch with staging
git checkout feature/your-feature
git fetch origin
git merge origin/staging

# Or use rebase for cleaner history
git rebase origin/staging
```

### Delete Merged Branches
- Always delete feature branches after merging
- Keeps repository clean
- Can be automated in GitHub settings

## CI/CD Integration

### Automated Deployments
- **Push to `staging`** → Deploy to staging environment
- **Push to `main`** → Deploy to production environment

### Status Checks (Required to Pass)
- ✅ Biome lint check
- ✅ TypeScript type check
- ✅ Unit tests (Vitest)
- ✅ E2E tests
- ✅ Build success
- ✅ Docker build success

## Emergency Procedures

### Rollback Production
```bash
# Option 1: Revert the merge commit
git checkout main
git revert -m 1 <merge-commit-hash>
git push origin main

# Option 2: Deploy previous version
git checkout main
git reset --hard <previous-good-commit>
git push -f origin main  # Requires admin override
```

### Hotfix Without PR (Emergency Only)
```bash
# Only in critical situations with admin privileges
git checkout main
git pull origin main
# Make critical fix
git add .
git commit -m "hotfix: critical production issue"
git push origin main  # Admin override required

# IMPORTANT: Also apply to staging immediately
git checkout staging
git cherry-pick <commit-hash>
git push origin staging
```

## Visual Workflow

```
┌─────────────────────────────────────────────────────────┐
│                     DEVELOPMENT CYCLE                    │
└─────────────────────────────────────────────────────────┘

1. Create Feature Branch
   staging ─────┬──→ feature/new-feature
                │
                └──→ feature/another-feature

2. Development & Testing
   feature/new-feature ──→ commits ──→ push ──→ PR

3. Code Review & Merge
   PR: feature/new-feature → staging ──→ Review ──→ Merge

4. Integration Testing
   staging ──→ Deploy to Staging ──→ QA Testing

5. Production Release
   PR: staging → main ──→ Review ──→ Merge ──→ Deploy to Prod

6. Tag Release
   main ──→ git tag v1.0.0 ──→ push tags
```

## FAQ

**Q: Can I push directly to `staging`?**
A: No, all changes must go through pull requests. This ensures code review and CI checks.

**Q: When should I create a hotfix branch?**
A: Only for critical production bugs that need immediate fixing. Use feature branches for regular bugs.

**Q: How often should I merge `staging` into my feature branch?**
A: At least once a day, or before creating a PR to avoid merge conflicts.

**Q: Can I work on multiple features simultaneously?**
A: Yes, create separate feature branches for each feature.

**Q: What if my PR conflicts with staging?**
A: Resolve conflicts locally by merging/rebasing staging into your feature branch, then push again.

**Q: Should I squash commits when merging?**
A: Yes, use "Squash and merge" on GitHub to keep main/staging history clean.

## Summary

✅ **DO**
- Create feature branches from `staging`
- Use descriptive branch and commit names
- Create PRs for all changes
- Keep your branch updated with staging
- Delete branches after merging
- Test thoroughly on staging before production

❌ **DON'T**
- Push directly to `main` or `staging`
- Create long-living feature branches
- Merge without code review
- Skip CI checks
- Force push to protected branches
- Leave merged branches undeleted

---

**Last Updated**: December 28, 2025
**Maintained By**: Development Team
**Questions?**: Create an issue or ask in team chat
