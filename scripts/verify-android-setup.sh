#!/bin/bash

echo "🔍 Android Development Environment Verification"
echo "==============================================="
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Check counter
CHECKS_PASSED=0
TOTAL_CHECKS=0

check_item() {
    TOTAL_CHECKS=$((TOTAL_CHECKS + 1))
    if [ $1 -eq 0 ]; then
        echo -e "${GREEN}✓${NC} $2"
        CHECKS_PASSED=$((CHECKS_PASSED + 1))
    else
        echo -e "${RED}✗${NC} $2"
        if [ ! -z "$3" ]; then
            echo -e "  ${YELLOW}→${NC} $3"
        fi
    fi
}

echo "1. Environment Variables"
echo "------------------------"

# Check ANDROID_HOME
if [ ! -z "$ANDROID_HOME" ]; then
    check_item 0 "ANDROID_HOME is set: $ANDROID_HOME"
else
    check_item 1 "ANDROID_HOME is set" "Run: source ~/.bashrc"
fi

# Check JAVA_HOME
if [ ! -z "$JAVA_HOME" ]; then
    check_item 0 "JAVA_HOME is set: $JAVA_HOME"
else
    check_item 1 "JAVA_HOME is set" "Run: source ~/.bashrc"
fi

echo ""
echo "2. Android Studio"
echo "-----------------"

# Check Android Studio installation
if [ -d "/opt/android-studio" ]; then
    check_item 0 "Android Studio installed at /opt/android-studio"
else
    check_item 1 "Android Studio installed" "Run setup-android-studio.sh"
fi

echo ""
echo "3. Android SDK Components"
echo "-------------------------"

# Check SDK directory
if [ -d "$ANDROID_HOME/platform-tools" ]; then
    check_item 0 "Android SDK platform-tools installed"
else
    check_item 1 "Android SDK platform-tools installed" "Complete Android Studio setup wizard"
fi

if [ -d "$ANDROID_HOME/platforms" ] && [ "$(ls -A $ANDROID_HOME/platforms 2>/dev/null)" ]; then
    PLATFORMS=$(ls -1 $ANDROID_HOME/platforms 2>/dev/null | tr '\n' ', ' | sed 's/,$//')
    check_item 0 "Android platforms installed: $PLATFORMS"
else
    check_item 1 "Android platforms installed" "Install via Android Studio SDK Manager"
fi

if [ -d "$ANDROID_HOME/build-tools" ] && [ "$(ls -A $ANDROID_HOME/build-tools 2>/dev/null)" ]; then
    BUILD_TOOLS=$(ls -1 $ANDROID_HOME/build-tools 2>/dev/null | tr '\n', ' ' | sed 's/ $//')
    check_item 0 "Build tools installed: $BUILD_TOOLS"
else
    check_item 1 "Build tools installed" "Install via Android Studio SDK Manager"
fi

if [ -d "$ANDROID_HOME/emulator" ] && [ -f "$ANDROID_HOME/emulator/emulator" ]; then
    check_item 0 "Android Emulator installed"
else
    check_item 1 "Android Emulator installed" "Install via Android Studio SDK Manager"
fi

echo ""
echo "4. Command Line Tools"
echo "---------------------"

# Check adb
if command -v adb &> /dev/null; then
    ADB_VERSION=$(adb --version 2>&1 | head -n1)
    check_item 0 "adb available: $ADB_VERSION"
else
    check_item 1 "adb (Android Debug Bridge) available" "Install platform-tools via SDK Manager"
fi

# Check sdkmanager
if command -v sdkmanager &> /dev/null; then
    check_item 0 "sdkmanager available"
else
    check_item 1 "sdkmanager available" "Install command-line tools via Android Studio"
fi

# Check Java
if command -v java &> /dev/null; then
    JAVA_VERSION=$(java -version 2>&1 | head -n1)
    check_item 0 "Java available: $JAVA_VERSION"
else
    check_item 1 "Java available" "Install: sudo apt install openjdk-17-jdk"
fi

echo ""
echo "5. Virtual Devices"
echo "------------------"

# Check for AVDs
if [ -d "$HOME/.android/avd" ] && [ "$(ls -A $HOME/.android/avd 2>/dev/null | grep -c '\.avd$')" -gt 0 ]; then
    AVD_COUNT=$(ls -1 $HOME/.android/avd 2>/dev/null | grep -c '\.avd$')
    AVD_NAMES=$(ls -1 $HOME/.android/avd 2>/dev/null | grep '\.avd$' | sed 's/\.avd$//' | tr '\n' ', ' | sed 's/,$//')
    check_item 0 "Android Virtual Devices ($AVD_COUNT): $AVD_NAMES"
else
    check_item 1 "Android Virtual Devices created" "Create via Android Studio Device Manager"
fi

echo ""
echo "═══════════════════════════════════════════════"
echo -e "Results: ${GREEN}$CHECKS_PASSED${NC}/$TOTAL_CHECKS checks passed"
echo "═══════════════════════════════════════════════"
echo ""

if [ $CHECKS_PASSED -eq $TOTAL_CHECKS ]; then
    echo -e "${GREEN}✓ Your Android development environment is fully configured!${NC}"
    echo ""
    echo "You can now run:"
    echo "  • pnpm android (from mobile app directory)"
    echo "  • expo start --android"
    echo ""
elif [ $CHECKS_PASSED -lt 3 ]; then
    echo -e "${RED}✗ Your environment needs setup. Follow these steps:${NC}"
    echo ""
    echo "1. Launch Android Studio:"
    echo "   /opt/android-studio/bin/studio.sh"
    echo ""
    echo "2. Complete the setup wizard (choose 'Standard' installation)"
    echo ""
    echo "3. Install SDK components:"
    echo "   • Open Tools > SDK Manager"
    echo "   • Install Android SDK Platform 34"
    echo "   • Install Android SDK Build-Tools"
    echo "   • Install Android Emulator"
    echo "   • Install Android SDK Command-line Tools"
    echo ""
    echo "4. Create an AVD:"
    echo "   • Open Tools > Device Manager"
    echo "   • Create a new virtual device"
    echo ""
    echo "5. Run this script again to verify"
    echo ""
else
    echo -e "${YELLOW}⚠ Your environment is partially configured.${NC}"
    echo "   Review the failed checks above and complete the missing steps."
    echo ""
fi
