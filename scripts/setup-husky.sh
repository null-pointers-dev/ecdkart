#!/bin/bash

# Setup script for Husky Git hooks
# Run this after cloning the repository

set -e

echo "🔧 Setting up Git hooks with Husky..."

# Check if Git is initialized
if [ ! -d .git ]; then
    echo "⚠️  Git repository not found. Initializing..."
    git init
    echo "✅ Git initialized"
fi

# Configure Git to use .husky for hooks
git config core.hooksPath .husky
echo "✅ Git hooks configured"

# Make pre-commit executable
chmod +x .husky/pre-commit
echo "✅ Pre-commit hook is executable"

# Test the setup
echo ""
echo "🎉 Husky setup complete!"
echo ""
echo "Git hooks are now active. The pre-commit hook will:"
echo "  • Format code with Biome"
echo "  • Lint and fix issues"
echo "  • Only on staged files"
echo ""
echo "To test, try:"
echo "  git add ."
echo "  git commit -m 'test'"
