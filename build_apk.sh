#!/bin/bash

echo "🛑 Stopping any running Flutter processes..."
pkill -9 flutter 2>/dev/null || true
pkill -9 dart 2>/dev/null || true
sleep 2

echo ""
echo "🧹 Cleaning previous builds..."
cd /workspaces/VisionBreak
flutter clean

echo ""
echo "📦 Getting dependencies..."
flutter pub get

echo ""
echo "🔨 Building Release APKs (this may take 5-10 minutes)..."
flutter build apk --release --split-per-abi

echo ""
echo "✅ Build complete!"
echo ""
echo "📱 Your APKs are ready at:"
echo "   build/app/outputs/flutter-apk/"
ls -lh build/app/outputs/flutter-apk/*.apk

echo ""
echo "📥 To download:"
echo "   1. Open the Explorer panel (left sidebar)"
echo "   2. Navigate to: build/app/outputs/flutter-apk/"
echo "   3. Right-click on app-arm64-v8a-release.apk"
echo "   4. Select 'Download'"
echo "   5. Install on your Android device"
echo ""
echo "🎉 Done!"
