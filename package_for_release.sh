#!/bin/bash

# 🚀 JamfKiller - One-Click Release Packager
# Everything you need to create a shareable release

echo "🚀 JamfKiller Release Packager"
echo "==============================="

# Check if we're in the right directory
if [ ! -f "Package.swift" ]; then
    echo "❌ Error: Run this from the JamfKiller project directory"
    exit 1
fi

# Create the DMG
echo "📦 Creating professional DMG package..."
./create_dmg.sh

# Check if DMG was created successfully
if [ -f "JamfKiller-v1.0.0.dmg" ]; then
    echo ""
    echo "🎉 RELEASE READY!"
    echo "=================="
    echo ""
    echo "✅ Your JamfKiller-v1.0.0.dmg is ready for sharing!"
    echo ""
    echo "📤 Distribution options:"
    echo "   1. 📧 Email the DMG file directly"
    echo "   2. 🌐 Upload to GitHub Releases"
    echo "   3. ☁️  Upload to Google Drive/Dropbox"
    echo "   4. 💬 Share via Slack/Teams"
    echo ""
    echo "👥 Users just need to:"
    echo "   1. Download the DMG"
    echo "   2. Double-click to open"
    echo "   3. Drag JamfKiller.app to Applications"
    echo "   4. Launch and enjoy popup-free computing!"
    echo ""
    echo "🎯 Pro tip: Test the DMG yourself first!"
    echo "   Run: open JamfKiller-v1.0.0.dmg"
else
    echo "❌ DMG creation failed. Check the error messages above."
    exit 1
fi 