#!/bin/bash

echo "🚀 Building JamfKiller (Swift Package)..."
echo ""

# Check development tools
echo "🔍 Checking development environment..."
echo "Swift version: $(swift --version | head -1)"
echo "Xcode path: $(xcode-select --print-path)"
echo "Command Line Tools version: $(pkgutil --pkg-info=com.apple.pkg.CLTools_Executables 2>/dev/null | grep version || echo 'Not found')"
echo ""

# Check if using Command Line Tools vs full Xcode
if [[ "$(xcode-select --print-path)" == *"CommandLineTools"* ]]; then
    echo "⚠️  Warning: Using Command Line Tools instead of full Xcode"
    echo "   This may cause build issues. Consider:"
    echo "   1. Install Xcode from App Store, or"
    echo "   2. Update Command Line Tools: sudo xcode-select --install"
    echo "   3. Switch to Xcode: sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer"
    echo ""
fi

# Set the macOS deployment target to ensure compatibility
export MACOSX_DEPLOYMENT_TARGET=14.0

# Clean any previous builds
echo "🧹 Cleaning previous builds..."
swift package clean

# Build the package
echo "🔨 Building JamfKiller app..."
swift build --configuration release

# Check if build was successful
if [ $? -eq 0 ]; then
    echo "✅ Build successful!"
    echo "📦 Executable location: ./.build/release/JamfKiller"
    echo ""
    echo "🎯 To run the app:"
    echo "   ./.build/release/JamfKiller"
    echo ""
    echo "🚀 Or run directly with:"
    echo "   swift run"
    echo ""
    echo "💡 For development with hot reload:"
    echo "   swift run --skip-build"
else
    echo "❌ Build failed!"
    echo "💡 Try running: swift package resolve"
    exit 1
fi

echo ""
echo "🎉 JamfKiller is ready to eliminate those annoying popups!"
echo "💀 Ultra Kill Mode: 0.1s monitoring intervals"
echo "🎨 Beautiful UI with animations and gradients" 