#!/bin/bash

echo "🤖 Android Studio & Flutter/Expo Setup for Ubuntu"
echo "=================================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Step 1: Install Android Studio
echo -e "${GREEN}Step 1: Installing Android Studio${NC}"
echo "-----------------------------------"

ANDROID_STUDIO_DIR="/home/apt/Downloads/android-studio-2025.2.2.8-linux"

if [ -d "$ANDROID_STUDIO_DIR" ]; then
    echo "✓ Android Studio found at $ANDROID_STUDIO_DIR"
    
    # Extract if it's a tar.gz file
    if [ -f "$ANDROID_STUDIO_DIR/android-studio-2025.2.2.8-linux.tar.gz" ]; then
        echo "Extracting Android Studio..."
        cd /home/apt/Downloads
        tar -xzf android-studio-2025.2.2.8-linux.tar.gz
    fi
    
    # Move to /opt (recommended location)
    echo "Moving Android Studio to /opt..."
    sudo mv $ANDROID_STUDIO_DIR/android-studio /opt/ 2>/dev/null || sudo mv /home/apt/Downloads/android-studio /opt/
    
    # Create desktop entry
    echo "Creating desktop shortcut..."
    cat > ~/.local/share/applications/android-studio.desktop << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Android Studio
Icon=/opt/android-studio/bin/studio.svg
Exec="/opt/android-studio/bin/studio.sh" %f
Comment=The Drive to Develop
Categories=Development;IDE;
Terminal=false
StartupWMClass=jetbrains-studio
EOF
    
    chmod +x ~/.local/share/applications/android-studio.desktop
    
    echo -e "${GREEN}✓ Android Studio installed to /opt/android-studio${NC}"
else
    echo -e "${RED}✗ Android Studio directory not found!${NC}"
    echo "Please check the path: $ANDROID_STUDIO_DIR"
    exit 1
fi

echo ""

# Step 2: Install required dependencies
echo -e "${GREEN}Step 2: Installing Required Dependencies${NC}"
echo "----------------------------------------"

# Enable i386 architecture (for 32-bit libraries)
echo "Enabling i386 architecture..."
sudo dpkg --add-architecture i386

sudo apt-get update

# Install packages with error handling
echo "Installing JDK and virtualization tools..."
sudo apt-get install -y openjdk-17-jdk qemu-system-x86 libvirt-daemon-system libvirt-clients bridge-utils || {
    echo -e "${YELLOW}⚠ Some packages failed to install, continuing...${NC}"
}

# Try to install 32-bit libraries (may not be available on all Ubuntu versions)
echo "Attempting to install 32-bit libraries (optional for some Android tools)..."
sudo apt-get install -y \
    libc6:i386 \
    libstdc++6:i386 \
    lib32z1 \
    libncurses6:i386 2>/dev/null || {
    echo -e "${YELLOW}⚠ 32-bit libraries not available (this is normal on modern Ubuntu)${NC}"
    echo -e "${YELLOW}  Android Studio will work fine without them${NC}"
}

echo -e "${GREEN}✓ Core dependencies installed${NC}"
echo ""

# Step 3: Set up environment variables
echo -e "${GREEN}Step 3: Setting up Environment Variables${NC}"
echo "----------------------------------------"

# Detect shell
if [ -f ~/.zshrc ]; then
    SHELL_RC=~/.zshrc
else
    SHELL_RC=~/.bashrc
fi

# Check if Android environment variables already exist
if grep -q "# Android SDK" $SHELL_RC; then
    echo "✓ Android environment variables already configured in $SHELL_RC"
else
    # Backup existing rc file
    cp $SHELL_RC ${SHELL_RC}.backup.$(date +%Y%m%d_%H%M%S)
    
    # Add Android environment variables
    cat >> $SHELL_RC << 'EOF'

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

    echo -e "${GREEN}✓ Environment variables added to $SHELL_RC${NC}"
fi
echo ""

# Step 4: Create Android SDK directory
echo -e "${GREEN}Step 4: Creating Android SDK Directory${NC}"
echo "--------------------------------------"

mkdir -p $HOME/Android/Sdk

echo -e "${GREEN}✓ Android SDK directory created${NC}"
echo ""

# Step 5: Instructions for completing setup
echo -e "${YELLOW}============================================${NC}"
echo -e "${YELLOW}  NEXT STEPS - IMPORTANT!${NC}"
echo -e "${YELLOW}============================================${NC}"
echo ""
echo "1. Reload your shell configuration:"
echo -e "   ${GREEN}source $SHELL_RC${NC}"
echo ""
echo "2. Launch Android Studio:"
echo -e "   ${GREEN}/opt/android-studio/bin/studio.sh${NC}"
echo "   Or search for 'Android Studio' in your applications menu"
echo ""
echo "3. In Android Studio Setup Wizard:"
echo "   • Choose 'Standard' installation"
echo "   • Accept all licenses"
echo "   • Let it download Android SDK, SDK Tools, and Emulator"
echo "   • Install Android SDK Platform 34 (or latest)"
echo "   • Install Android SDK Build-Tools"
echo "   • Install Android Emulator"
echo ""
echo "4. After Android Studio setup, accept SDK licenses:"
echo -e "   ${GREEN}yes | sdkmanager --licenses${NC}"
echo ""
echo "5. Install required SDK packages:"
echo -e "   ${GREEN}sdkmanager \"platform-tools\" \"platforms;android-34\" \"build-tools;34.0.0\" \"emulator\"${NC}"
echo ""
echo "6. Create an Android Virtual Device (AVD):"
echo "   • Open Android Studio > Tools > Device Manager"
echo "   • Click 'Create Device'"
echo "   • Choose a device (Pixel 6 recommended)"
echo "   • Download a system image (Android 14/API 34 recommended)"
echo "   • Finish setup"
echo ""
echo "7. Verify installation:"
echo -e "   ${GREEN}flutter doctor${NC}"
echo -e "   ${GREEN}expo doctor${NC}"
echo ""
echo -e "${YELLOW}============================================${NC}"
echo ""
echo -e "${GREEN}Setup script completed!${NC}"
echo "Follow the steps above to complete Android Studio configuration."