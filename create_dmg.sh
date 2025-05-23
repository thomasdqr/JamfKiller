#!/bin/bash

# 💀 JamfKiller DMG Creator
# Creates a professional, installable DMG for easy sharing

set -e  # Exit on any error

# Configuration
APP_NAME="JamfKiller"
APP_BUNDLE="${APP_NAME}.app"
VERSION="1.0.0"
DMG_NAME="${APP_NAME}-v${VERSION}"
TEMP_DMG="${DMG_NAME}-temp.dmg"
FINAL_DMG="${DMG_NAME}.dmg"
VOLUME_NAME="JamfKiller Installer"
BACKGROUND_FILE="dmg_background.png"

echo "💀 JamfKiller DMG Creator v${VERSION}"
echo "================================================"

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
SIZE_MB=50  # DMG size in MB
hdiutil create -size ${SIZE_MB}m -fs HFS+ -volname "${VOLUME_NAME}" "${TEMP_DMG}"

# Step 3: Mount the temporary DMG
echo "💿 Mounting temporary DMG..."

# Mount and get the mount point more reliably
MOUNT_OUTPUT=$(hdiutil attach "${TEMP_DMG}" -readwrite -noverify -noautoopen)
MOUNT_POINT=$(echo "${MOUNT_OUTPUT}" | grep -E "^/dev/" | tail -1 | awk '{for(i=3;i<=NF;i++) printf "%s ", $i; print ""}' | sed 's/[[:space:]]*$//')

# Verify mount point exists and is writable
if [ ! -d "${MOUNT_POINT}" ]; then
    echo "❌ Error: Could not determine mount point"
    echo "Mount output: ${MOUNT_OUTPUT}"
    exit 1
fi

echo "📁 Mount point: ${MOUNT_POINT}"

# Test if mount point is writable
if [ ! -w "${MOUNT_POINT}" ]; then
    echo "❌ Error: Mount point is not writable"
    echo "Attempting to remount with write permissions..."
    hdiutil detach "${MOUNT_POINT}" 2>/dev/null || true
    sleep 1
    MOUNT_OUTPUT=$(hdiutil attach "${TEMP_DMG}" -readwrite -noverify -noautoopen -nobrowse)
    MOUNT_POINT=$(echo "${MOUNT_OUTPUT}" | grep -E "^/dev/" | tail -1 | awk '{for(i=3;i<=NF;i++) printf "%s ", $i; print ""}' | sed 's/[[:space:]]*$//')
fi

# Wait a moment for the mount to stabilize
sleep 1

# Step 4: Copy app to DMG
echo "📋 Copying JamfKiller.app to DMG..."

# Debug info
echo "🔍 Debug info:"
echo "   App bundle: ${APP_BUNDLE}"
echo "   Mount point: ${MOUNT_POINT}"
echo "   Mount point writable: $([ -w "${MOUNT_POINT}" ] && echo "YES" || echo "NO")"
echo "   App bundle exists: $([ -d "${APP_BUNDLE}" ] && echo "YES" || echo "NO")"

# Copy with error handling
if ! cp -R "${APP_BUNDLE}" "${MOUNT_POINT}/"; then
    echo "❌ Error: Failed to copy app to DMG"
    echo "Attempting alternative copy method..."
    
    # Try with sudo (sometimes needed for disk operations)
    if ! sudo cp -R "${APP_BUNDLE}" "${MOUNT_POINT}/"; then
        echo "❌ Error: All copy methods failed"
        hdiutil detach "${MOUNT_POINT}" 2>/dev/null || true
        exit 1
    fi
fi

# Verify the copy worked
if [ ! -d "${MOUNT_POINT}/${APP_BUNDLE}" ]; then
    echo "❌ Error: App was not copied successfully"
    hdiutil detach "${MOUNT_POINT}" 2>/dev/null || true
    exit 1
fi

echo "✅ App copied successfully"

# Step 5: Create Applications symlink
echo "🔗 Creating Applications folder shortcut..."
if ! ln -s /Applications "${MOUNT_POINT}/Applications"; then
    echo "⚠️  Warning: Could not create Applications symlink (continuing anyway)"
fi

# Step 6: Create ultra-clean DMG appearance
echo "🎨 Setting up ultra-clean DMG appearance..."

# Step 7: Set DMG window properties using AppleScript
echo "⚙️  Configuring clean DMG window layout..."

# Try to configure the DMG appearance with error handling  
if ! osascript << EOF
tell application "Finder"
    tell disk "${VOLUME_NAME}"
        open
        set current view of container window to icon view
        set toolbar visible of container window to false
        set statusbar visible of container window to false
        set the bounds of container window to {100, 100, 500, 320}
        set theViewOptions to the icon view options of container window
        set arrangement of theViewOptions to not arranged
        set icon size of theViewOptions to 96
        
        -- Position icons in a clean, centered layout
        set position of item "${APP_BUNDLE}" of container window to {140, 180}
        set position of item "Applications" of container window to {320, 180}
        
        -- Update and close
        update without registering applications
        delay 2
        close
    end tell
end tell
EOF
then
    echo "⚠️  Warning: Could not configure DMG window layout (continuing anyway)"
    echo "   The DMG will still work, just without custom appearance"
fi

# Step 8: Set proper permissions
echo "🔐 Setting proper permissions..."
chmod -Rf go-w "${MOUNT_POINT}"
sync

# Step 9: Unmount temporary DMG
echo "⏏️  Unmounting temporary DMG..."
hdiutil detach "${MOUNT_POINT}"

# Step 10: Convert to final compressed DMG
echo "🗜️  Creating final compressed DMG..."
hdiutil convert "${TEMP_DMG}" -format UDZO -imagekey zlib-level=9 -o "${FINAL_DMG}"

# Step 11: Clean up
echo "🧹 Cleaning up temporary files..."
rm -f "${TEMP_DMG}"

# Step 12: Verify DMG
echo "🔍 Verifying DMG..."
if [ -f "${FINAL_DMG}" ]; then
    DMG_SIZE=$(du -h "${FINAL_DMG}" | cut -f1)
    echo ""
    echo "🎉 SUCCESS! DMG created successfully!"
    echo "================================================"
    echo "📁 File: ${FINAL_DMG}"
    echo "📏 Size: ${DMG_SIZE}"
    echo ""
    echo "🚀 Ready for distribution!"
    echo ""
    echo "📤 Next steps:"
    echo "   1. Test the DMG: open '${FINAL_DMG}'"
    echo "   2. Upload to GitHub Releases"
    echo "   3. Share the download link!"
    echo ""
    echo "💡 Users install by:"
    echo "   1. Download ${FINAL_DMG}"
    echo "   2. Open DMG file"
    echo "   3. Drag JamfKiller.app to Applications"
    echo ""
    
    # Ask if user wants to test the DMG
    echo "🧪 Test the DMG now? (y/n)"
    read -r test_dmg
    if [[ "$test_dmg" == "y" || "$test_dmg" == "Y" ]]; then
        echo "🎯 Opening DMG for testing..."
        open "${FINAL_DMG}"
    fi
else
    echo "❌ Error: DMG creation failed!"
    exit 1
fi 