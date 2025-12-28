# Documentation

Welcome to the ECDKart project documentation. This directory contains comprehensive guides for development, deployment, and project maintenance.

## 📚 Documentation Index

### Project Setup & Configuration
- **[Branching Strategy](./BRANCHING_STRATEGY.md)** - Git workflow, branch protection, and PR guidelines
- **[Biome Configuration](./BIOME_CONFIG.md)** - Code formatting and linting setup for monorepo
- **[Husky Setup](./HUSKY_SETUP.md)** - Git hooks and pre-commit checks configuration
- **[Node Version Enforcement](./NODE_VERSION.md)** - Node.js version management and enforcement
- **[Version Enforcement](./VERSION_ENFORCEMENT.md)** - Complete guide to enforcing Node.js and pnpm versions

### Backend Documentation
Located in `apps/backend/`:
- **[Getting Started](../apps/backend/GETTING_STARTED.md)** - Quick start guide for backend development
- **[Architecture](../apps/backend/ARCHITECTURE.md)** - Backend architecture and design decisions
- **[Setup Guide](../apps/backend/SETUP.md)** - Detailed backend setup instructions
- **[Vitest Guide](../apps/backend/VITEST.md)** - Testing framework setup and usage
- **[Docker Infrastructure](../apps/backend/infra/README.md)** - Docker setup for development and production

### Scripts Documentation
- **[Scripts Guide](../scripts/README.md)** - All available scripts and their usage

## 🚀 Quick Links

### For New Developers
1. Read [Branching Strategy](./BRANCHING_STRATEGY.md) first
2. Setup your environment with [Node Version Enforcement](./NODE_VERSION.md)
3. Configure your editor with [Biome Configuration](./BIOME_CONFIG.md)
4. Setup Git hooks with [Husky Setup](./HUSKY_SETUP.md)
5. Start backend development with [Getting Started](../apps/backend/GETTING_STARTED.md)

### For Code Review
- [Branching Strategy - PR Guidelines](./BRANCHING_STRATEGY.md#pull-request-guidelines)
- [Biome Configuration - Linting Rules](./BIOME_CONFIG.md)

### For DevOps
- [Docker Infrastructure](../apps/backend/infra/README.md)
- [GitHub Actions CI/CD](./.github/workflows/) *(coming soon)*

## 📝 Documentation Updates

To update documentation:

```bash
# Create docs branch from staging
git checkout staging
git pull origin staging
git checkout -b docs/your-update-name

# Make changes to docs
# ... edit documentation files ...

# Commit and push
git add docs/
git commit -m "docs: your change description"
git push -u origin docs/your-update-name

# Create PR on GitHub: docs/your-update-name → staging
```

Documentation PRs are fast-tracked for review since they don't affect code functionality.

## 🏗️ Project Structure

```
ecdkart/
├── docs/                          # 📚 This directory
│   ├── README.md                  # Documentation index
│   ├── BRANCHING_STRATEGY.md      # Git workflow
│   ├── BIOME_CONFIG.md            # Code quality setup
│   ├── HUSKY_SETUP.md             # Git hooks setup
│   ├── NODE_VERSION.md            # Node.js version guide
│   └── VERSION_ENFORCEMENT.md     # Version enforcement
├── apps/
│   ├── backend/                   # NestJS backend
│   │   ├── GETTING_STARTED.md
│   │   ├── ARCHITECTURE.md
│   │   ├── SETUP.md
│   │   └── VITEST.md
│   ├── admin/                     # Admin dashboard (coming soon)
│   └── mobile/                    # Mobile app (coming soon)
├── packages/
│   ├── ui/                        # Shared UI components
│   └── types/                     # Shared TypeScript types
└── scripts/                       # Build and utility scripts
    └── README.md                  # Scripts documentation
```

## 🤝 Contributing

All documentation contributions are welcome! Please follow these guidelines:

1. **Keep it clear**: Use simple language and examples
2. **Keep it updated**: Update docs when code changes
3. **Keep it organized**: Follow the existing structure
4. **Use markdown**: Proper formatting with headers, code blocks, and lists
5. **Add screenshots**: Visual aids help understanding (when relevant)

## 📞 Getting Help

- **Questions about documentation?** Create an issue with `documentation` label
- **Found an error?** Submit a PR with the fix
- **Need clarification?** Ask in team chat or create a discussion

---

**Last Updated**: December 28, 2025
**Maintained By**: Development Team
