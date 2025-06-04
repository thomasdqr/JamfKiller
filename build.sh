#!/bin/bash

echo "🚀 Building JamfKiller (Swift Package)..."

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