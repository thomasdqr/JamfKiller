#!/bin/bash

# 🚀 JamfKiller - Clean Release Packager
# Creates an ultra-clean, minimal DMG for sharing

echo "🚀 JamfKiller Clean Release Packager"
echo "====================================="

# Check if we're in the right directory
if [ ! -f "Package.swift" ]; then
    echo "❌ Error: Run this from the JamfKiller project directory"
    exit 1
fi

# Create the clean DMG
echo "📦 Creating ultra-clean DMG package..."
./create_simple_dmg.sh

# Check if DMG was created successfully
if [ -f "JamfKiller-v1.0.0.dmg" ]; then
    echo ""
    echo "🎉 CLEAN RELEASE READY!"
    echo "======================="
    echo ""
    echo "✅ Your ultra-clean JamfKiller-v1.0.0.dmg is ready!"
    echo ""
    echo "✨ What's inside:"
    echo "   • JamfKiller.app (your beautiful app)"
    echo "   • Applications folder shortcut"
    echo "   • Nothing else - pure simplicity!"
    echo ""
    echo "📤 Share it anywhere:"
    echo "   📧 Email attachment"
    echo "   🌐 GitHub Releases"
    echo "   ☁️  Cloud storage"
    echo "   💬 Team chat"
    echo ""
    echo "👥 Recipients just:"
    echo "   1. Download JamfKiller-v1.0.0.dmg"
    echo "   2. Double-click to open"
    echo "   3. Drag app → Applications"
    echo "   4. Done! 🎯"
    echo ""
    
    # Show file size
    DMG_SIZE=$(du -h "JamfKiller-v1.0.0.dmg" | cut -f1)
    echo "💾 File size: ${DMG_SIZE} (super compact!)"
    echo ""
    echo "🎯 Ready to share with the world!"
else
    echo "❌ Clean DMG creation failed. Check the error messages above."
    exit 1
fi 