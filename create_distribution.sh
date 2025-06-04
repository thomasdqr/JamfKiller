#!/bin/bash

echo "🚀 Creating JamfKiller Distribution Package"
echo "==========================================="
echo "This will create a signed app and DMG ready for sharing"
echo ""

set -e  # Exit on any error

APP_NAME="JamfKiller"
APP_BUNDLE="${APP_NAME}.app"
VERSION="1.0.0"
DMG_NAME="${APP_NAME}-v${VERSION}"
FINAL_DMG="${DMG_NAME}.dmg"

# Step 1: Clean previous builds
echo "🧹 Cleaning previous builds..."
rm -rf "${APP_BUNDLE}"
rm -f *.dmg

# Step 2: Build the app
echo "🔨 Building JamfKiller app..."
./create_app.sh

# Verify app was created and signed
if [ ! -d "${APP_BUNDLE}" ]; then
    echo "❌ Error: App bundle was not created!"
    exit 1
fi

# Step 3: Verify the app is signed
echo "🔍 Checking app signature..."
if codesign --verify "${APP_BUNDLE}" 2>/dev/null; then
    echo "✅ App is properly signed"
else
    echo "🔏 Re-signing app..."
    codesign --force --deep --sign - "${APP_BUNDLE}"
    echo "✅ App signed with ad-hoc signature"
fi

# Step 4: Create a simple DMG without the complex layout
echo "📦 Creating distribution DMG..."

# Create temporary DMG
SIZE_MB=20
hdiutil create -size ${SIZE_MB}m -fs HFS+ -volname "JamfKiller Installer" "${DMG_NAME}-temp.dmg"

# Mount the DMG
echo "💿 Mounting DMG..."
MOUNT_OUTPUT=$(hdiutil attach "${DMG_NAME}-temp.dmg" -readwrite -noverify -noautoopen)
MOUNT_POINT=$(echo "${MOUNT_OUTPUT}" | grep -E "^/dev/" | tail -1 | awk '{for(i=3;i<=NF;i++) printf "%s ", $i; print ""}' | sed 's/[[:space:]]*$//')

if [ ! -d "${MOUNT_POINT}" ]; then
    echo "❌ Error: Could not determine mount point"
    exit 1
fi

echo "📁 Mount point: ${MOUNT_POINT}"

# Copy app to DMG
echo "📋 Copying app to DMG..."
cp -R "${APP_BUNDLE}" "${MOUNT_POINT}/"

# Create Applications symlink
ln -s /Applications "${MOUNT_POINT}/Applications" 2>/dev/null || true

# Set permissions
chmod -Rf go-w "${MOUNT_POINT}" 2>/dev/null || true
sync

# Unmount
echo "⏏️  Unmounting DMG..."
hdiutil detach "${MOUNT_POINT}"

# Convert to compressed DMG
echo "🗜️  Creating final compressed DMG..."
hdiutil convert "${DMG_NAME}-temp.dmg" -format UDZO -imagekey zlib-level=9 -o "${FINAL_DMG}"

# Clean up
rm -f "${DMG_NAME}-temp.dmg"

# Final verification
if [ -f "${FINAL_DMG}" ]; then
    DMG_SIZE=$(du -h "${FINAL_DMG}" | cut -f1)
    echo ""
    echo "🎉 SUCCESS! Distribution package created!"
    echo "========================================"
    echo "📁 File: ${FINAL_DMG}"
    echo "📏 Size: ${DMG_SIZE}"
    echo ""
    echo "🚀 Ready for distribution!"
    echo ""
    echo "📤 Instructions for users:"
    echo "   1. Download ${FINAL_DMG}"
    echo "   2. Double-click to open the DMG"
    echo "   3. Drag JamfKiller.app to Applications folder"
    echo "   4. RIGHT-CLICK JamfKiller.app and select 'Open'"
    echo "   5. Click 'Open' when prompted about unidentified developer"
    echo "   6. After first launch, app will open normally"
    echo ""
    echo "💡 Key point: Users MUST right-click and 'Open' the first time!"
    echo "   This bypasses Gatekeeper and prevents the 'damaged' error."
    echo ""
    echo "🔓 If users still have issues, they can run:"
    echo "   sudo xattr -rd com.apple.quarantine /Applications/JamfKiller.app"
    echo ""
else
    echo "❌ Error: DMG creation failed!"
    exit 1
fi 