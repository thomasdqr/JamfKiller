#!/bin/bash

# 💀 JamfKiller Simple DMG Creator
# Creates a minimal, clean DMG for easy sharing

set -e  # Exit on any error

# Configuration
APP_NAME="JamfKiller"
APP_BUNDLE="${APP_NAME}.app"
VERSION="1.0.0"
DMG_NAME="${APP_NAME}-v${VERSION}"
TEMP_DMG="${DMG_NAME}-temp.dmg"
FINAL_DMG="${DMG_NAME}.dmg"
VOLUME_NAME="Install ${APP_NAME}"

echo "💀 JamfKiller Simple DMG Creator v${VERSION}"
echo "============================================="

# Step 1: Clean and build the app
echo "🧹 Cleaning previous builds..."
rm -rf "${APP_BUNDLE}"
rm -f "${TEMP_DMG}" "${FINAL_DMG}"

echo "🔨 Building JamfKiller app..."
./create_app.sh

# Verify app was created
if [ ! -d "${APP_BUNDLE}" ]; then
    echo "❌ Error: App bundle was not created!"
    exit 1
fi

echo "✅ App bundle created successfully"

# Step 2: Create temporary DMG
echo "📦 Creating temporary DMG..."
SIZE_MB=30  # Smaller DMG size
hdiutil create -size ${SIZE_MB}m -fs HFS+ -volname "${VOLUME_NAME}" "${TEMP_DMG}"

# Step 3: Mount the DMG
echo "💿 Mounting DMG..."
MOUNT_OUTPUT=$(hdiutil attach "${TEMP_DMG}" -readwrite -noverify -noautoopen -nobrowse)
MOUNT_POINT=$(echo "${MOUNT_OUTPUT}" | grep -E "^/dev/" | tail -1 | awk '{for(i=3;i<=NF;i++) printf "%s ", $i; print ""}' | sed 's/[[:space:]]*$//')

if [ ! -d "${MOUNT_POINT}" ] || [ ! -w "${MOUNT_POINT}" ]; then
    echo "❌ Error: Could not mount DMG properly"
    exit 1
fi

echo "📁 Mounted at: ${MOUNT_POINT}"

# Step 4: Copy app to DMG
echo "📋 Copying app to DMG..."
cp -R "${APP_BUNDLE}" "${MOUNT_POINT}/"

# Step 5: Create Applications symlink
echo "🔗 Creating Applications shortcut..."
ln -s /Applications "${MOUNT_POINT}/Applications"

# Step 6: Simple window layout (no complex AppleScript)
echo "⚙️  Setting basic window properties..."

# Just set the window to open and show icons nicely
osascript << EOF || echo "⚠️  Window layout skipped (DMG will still work)"
tell application "Finder"
    tell disk "${VOLUME_NAME}"
        open
        set current view of container window to icon view
        set toolbar visible of container window to false
        set statusbar visible of container window to false
        delay 1
        close
    end tell
end tell
EOF

# Step 7: Set permissions and unmount
echo "🔐 Setting permissions..."
chmod -Rf go-w "${MOUNT_POINT}"
sync

echo "⏏️  Unmounting DMG..."
hdiutil detach "${MOUNT_POINT}"

# Step 8: Convert to final compressed DMG
echo "🗜️  Creating final DMG..."
hdiutil convert "${TEMP_DMG}" -format UDZO -imagekey zlib-level=9 -o "${FINAL_DMG}"

# Step 9: Clean up
echo "🧹 Cleaning up..."
rm -f "${TEMP_DMG}"

# Step 10: Done!
if [ -f "${FINAL_DMG}" ]; then
    DMG_SIZE=$(du -h "${FINAL_DMG}" | cut -f1)
    echo ""
    echo "🎉 CLEAN DMG READY!"
    echo "==================="
    echo "📁 File: ${FINAL_DMG}"
    echo "📏 Size: ${DMG_SIZE}"
    echo ""
    echo "✨ Features:"
    echo "   • Ultra-clean layout"
    echo "   • Just app + Applications folder"
    echo "   • No clutter or extra files"
    echo "   • Perfect for sharing!"
    echo ""
    echo "🚀 Test it: open '${FINAL_DMG}'"
    echo ""
    
    # Auto-open for testing
    echo "🧪 Opening DMG for preview..."
    open "${FINAL_DMG}"
else
    echo "❌ Error: DMG creation failed!"
    exit 1
fi 