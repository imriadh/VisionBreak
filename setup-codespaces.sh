#!/bin/bash

# VisionBreak - GitHub Codespaces Setup Script
# This script installs Flutter and Android SDK in Codespaces

set -e

echo "🚀 Setting up VisionBreak development environment in GitHub Codespaces..."

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Install dependencies
echo -e "${BLUE}📦 Installing system dependencies...${NC}"
sudo apt-get update -qq
sudo apt-get install -y -qq curl git unzip xz-utils zip libglu1-mesa clang cmake ninja-build pkg-config libgtk-3-dev > /dev/null

# Install Flutter
echo -e "${BLUE}🐦 Installing Flutter...${NC}"
if [ ! -d "$HOME/flutter" ]; then
    cd $HOME
    git clone https://github.com/flutter/flutter.git -b stable --depth 1
    echo -e "${GREEN}✓ Flutter cloned${NC}"
else
    echo -e "${YELLOW}Flutter already installed${NC}"
fi

# Add Flutter to PATH
export PATH="$HOME/flutter/bin:$PATH"
echo 'export PATH="$HOME/flutter/bin:$PATH"' >> $HOME/.bashrc

# Run Flutter doctor
echo -e "${BLUE}🔧 Configuring Flutter...${NC}"
flutter config --no-analytics
flutter precache --web

echo -e "${BLUE}📱 Installing Android SDK...${NC}"
# Install Android command-line tools
ANDROID_SDK_ROOT="$HOME/android-sdk"
if [ ! -d "$ANDROID_SDK_ROOT" ]; then
    mkdir -p $ANDROID_SDK_ROOT/cmdline-tools
    cd $ANDROID_SDK_ROOT/cmdline-tools
    wget -q https://dl.google.com/android/repository/commandlinetools-linux-9477386_latest.zip
    unzip -q commandlinetools-linux-9477386_latest.zip
    mv cmdline-tools latest
    rm commandlinetools-linux-9477386_latest.zip
    echo -e "${GREEN}✓ Android SDK tools installed${NC}"
else
    echo -e "${YELLOW}Android SDK already installed${NC}"
fi

# Set Android environment variables
export ANDROID_SDK_ROOT="$HOME/android-sdk"
export ANDROID_HOME="$ANDROID_SDK_ROOT"
export PATH="$PATH:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$ANDROID_SDK_ROOT/platform-tools:$ANDROID_SDK_ROOT/emulator"

# Add to bashrc
echo 'export ANDROID_SDK_ROOT="$HOME/android-sdk"' >> $HOME/.bashrc
echo 'export ANDROID_HOME="$ANDROID_SDK_ROOT"' >> $HOME/.bashrc
echo 'export PATH="$PATH:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$ANDROID_SDK_ROOT/platform-tools:$ANDROID_SDK_ROOT/emulator"' >> $HOME/.bashrc

# Accept licenses
echo -e "${BLUE}📝 Accepting Android licenses...${NC}"
yes | sdkmanager --licenses > /dev/null 2>&1 || true

# Install required Android SDK components
echo -e "${BLUE}📥 Installing Android SDK components...${NC}"
sdkmanager --install "platform-tools" "platforms;android-34" "build-tools;34.0.0" > /dev/null 2>&1

# Configure Flutter to use Android SDK
flutter config --android-sdk $ANDROID_SDK_ROOT

echo -e "${BLUE}🔍 Running Flutter doctor...${NC}"
flutter doctor

echo ""
echo -e "${GREEN}✅ Setup complete!${NC}"
echo ""
echo -e "${BLUE}Next steps:${NC}"
echo "  1. Reload your terminal: source ~/.bashrc"
echo "  2. Navigate to project: cd /workspaces/VisionBreak"
echo "  3. Get dependencies: flutter pub get"
echo "  4. Build web version: flutter run -d web-server --web-port=8080"
echo ""
echo -e "${YELLOW}Note: In Codespaces, you can run the web version of the app.${NC}"
echo -e "${YELLOW}To build APK, run: flutter build apk --release --split-per-abi${NC}"
