#!/bin/bash

# Manual environment check script
# Checks Node.js, pnpm, and Docker versions
# Run this anytime to verify your development environment
#
# Usage: ./scripts/check-env.sh

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "🔍 Checking development environment versions..."
echo ""

# Required versions
REQUIRED_NODE="22.12.0"
REQUIRED_PNPM="10.26.2"

# Get current versions
CURRENT_NODE=$(node --version | sed 's/v//')
CURRENT_PNPM=$(pnpm --version 2>/dev/null || echo "not installed")

# Check Node.js version
echo -n "Node.js: "
NODE_MAJOR=$(echo $CURRENT_NODE | cut -d. -f1)
REQUIRED_NODE_MAJOR=$(echo $REQUIRED_NODE | cut -d. -f1)

if [ "$NODE_MAJOR" -ge "$REQUIRED_NODE_MAJOR" ]; then
    echo -e "${GREEN}✅ v$CURRENT_NODE${NC} (required: >=$REQUIRED_NODE)"
else
    echo -e "${RED}❌ v$CURRENT_NODE${NC} (required: >=$REQUIRED_NODE)"
    echo ""
    echo -e "${YELLOW}To fix this:${NC}"
    echo "  nvm install && nvm use"
    echo "  # or"
    echo "  fnm install && fnm use"
    exit 1
fi

# Check pnpm version
echo -n "pnpm:    "
if [ "$CURRENT_PNPM" = "not installed" ]; then
    echo -e "${RED}❌ Not installed${NC} (required: >=$REQUIRED_PNPM)"
    echo ""
    echo -e "${YELLOW}To fix this:${NC}"
    echo "  corepack enable"
    echo "  corepack prepare pnpm@$REQUIRED_PNPM --activate"
    exit 1
else
    PNPM_MAJOR=$(echo $CURRENT_PNPM | cut -d. -f1)
    REQUIRED_PNPM_MAJOR=$(echo $REQUIRED_PNPM | cut -d. -f1)
    
    if [ "$PNPM_MAJOR" -ge "$REQUIRED_PNPM_MAJOR" ]; then
        echo -e "${GREEN}✅ v$CURRENT_PNPM${NC} (required: >=$REQUIRED_PNPM)"
    else
        echo -e "${RED}❌ v$CURRENT_PNPM${NC} (required: >=$REQUIRED_PNPM)"
        echo ""
        echo -e "${YELLOW}To fix this:${NC}"
        echo "  corepack enable"
        echo "  corepack prepare pnpm@$REQUIRED_PNPM --activate"
        exit 1
    fi
fi

# Check Docker (optional)
echo ""
echo -n "Docker:  "
if command -v docker &> /dev/null; then
    DOCKER_VERSION=$(docker --version | grep -oP '\d+\.\d+\.\d+' | head -1)
    echo -e "${GREEN}✅ v$DOCKER_VERSION${NC}"
else
    echo -e "${YELLOW}⚠️  Not installed${NC} (optional, needed for Docker development)"
fi

echo ""
echo -e "${GREEN}🎉 All required tools are correctly installed!${NC}"
echo ""
echo "Run 'pnpm install' to install dependencies."
