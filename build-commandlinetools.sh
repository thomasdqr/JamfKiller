#!/bin/bash

echo "🚀 Building JamfKiller (Command Line Tools compatible)..."
echo ""

# Set environment variables for Command Line Tools compatibility
export MACOSX_DEPLOYMENT_TARGET=14.0
export DEVELOPER_DIR="/Library/Developer/CommandLineTools"

# Clean any previous builds
echo "🧹 Cleaning previous builds..."
swift package clean

# Build with explicit flags for Command Line Tools
echo "🔨 Building JamfKiller app..."
swift build \
    --configuration release \
    -Xswiftc -target \
    -Xswiftc arm64-apple-macosx14.0 \
    -Xswiftc -sdk \
    -Xswiftc "$(xcrun --sdk macosx --show-sdk-path)"

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
    echo "💡 Or update Command Line Tools: sudo xcode-select --install"
    exit 1
fi

echo ""
echo "🎉 JamfKiller is ready to eliminate those annoying popups!"
echo "💀 Ultra Kill Mode: 0.1s monitoring intervals"
echo "🎨 Beautiful UI with animations and gradients" 