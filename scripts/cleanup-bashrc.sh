#!/bin/bash

echo "🧹 Cleaning up duplicate Android SDK entries in .bashrc"
echo "========================================================"
echo ""

BASHRC="$HOME/.bashrc"
BACKUP="$HOME/.bashrc.backup.$(date +%Y%m%d_%H%M%S)"

# Create backup
cp "$BASHRC" "$BACKUP"
echo "✓ Backup created: $BACKUP"

# Remove all Android SDK sections
sed -i '/# Android SDK/,/# Java/{/# Java/!d;}' "$BASHRC"
sed -i '/# Java/,+2d' "$BASHRC"

# Add clean version once at the end
cat >> "$BASHRC" << 'EOF'

# Android SDK
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin

# Java
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
export PATH=$PATH:$JAVA_HOME/bin
EOF

echo "✓ Cleaned up duplicate entries"
echo ""
echo "Run 'source ~/.bashrc' to reload your configuration"
