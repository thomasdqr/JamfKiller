#!/bin/bash

echo "🚀 Creating JamfKiller.app bundle..."

# Build release version
echo "🔨 Building release version..."
swift build --configuration release

# Check if build was successful
if [ $? -ne 0 ]; then
    echo "❌ Build failed!"
    exit 1
fi

# Create app bundle structure
APP_NAME="JamfKiller"
APP_BUNDLE="${APP_NAME}.app"
CONTENTS_DIR="${APP_BUNDLE}/Contents"
MACOS_DIR="${CONTENTS_DIR}/MacOS"
RESOURCES_DIR="${CONTENTS_DIR}/Resources"

echo "📦 Creating app bundle structure..."
rm -rf "${APP_BUNDLE}"
mkdir -p "${MACOS_DIR}"
mkdir -p "${RESOURCES_DIR}"

# Copy executable
echo "📋 Copying executable..."
cp ".build/release/${APP_NAME}" "${MACOS_DIR}/"

# Copy app icon
echo "🎨 Copying app icon..."
if [ -f "AppIcon.icns" ]; then
    cp "AppIcon.icns" "${RESOURCES_DIR}/"
    echo "✅ AppIcon.icns copied to Resources"
else
    echo "⚠️  AppIcon.icns not found, app will use default icon"
fi

# Create Info.plist
echo "📄 Creating Info.plist..."
cat > "${CONTENTS_DIR}/Info.plist" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>${APP_NAME}</string>
    <key>CFBundleIdentifier</key>
    <string>com.jamfkiller.app</string>
    <key>CFBundleName</key>
    <string>${APP_NAME}</string>
    <key>CFBundleDisplayName</key>
    <string>Jamf Killer</string>
    <key>CFBundleVersion</key>
    <string>1.0</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleSignature</key>
    <string>????</string>
    <key>CFBundleIconFile</key>
    <string>AppIcon</string>
    <key>LSMinimumSystemVersion</key>
    <string>14.0</string>
    <key>LSUIElement</key>
    <false/>
    <key>NSHighResolutionCapable</key>
    <true/>
    <key>NSSupportsAutomaticGraphicsSwitching</key>
    <true/>
    <key>LSApplicationCategoryType</key>
    <string>public.app-category.utilities</string>
</dict>
</plist>
EOF

# Create app icon (using system skull icon as ASCII art in icns format is complex)
echo "🎨 Creating app icon..."
# We'll use the default app icon for now, but you could add a custom icon here

echo "✅ App bundle created successfully!"
echo ""
echo "🎯 Your app is ready: ${APP_BUNDLE}"
echo ""
echo "📱 To install:"
echo "   cp -r ${APP_BUNDLE} /Applications/"
echo ""
echo "🚀 To run from current location:"
echo "   open ${APP_BUNDLE}"
echo ""
echo "💡 To test immediately:"
echo "   open ${APP_BUNDLE}"

# Make it executable
chmod +x "${MACOS_DIR}/${APP_NAME}"

echo ""
echo "🎉 JamfKiller.app is ready to eliminate popups!"
echo "💀 Double-click to launch with full window focus!" 