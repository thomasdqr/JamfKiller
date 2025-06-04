#!/bin/bash

echo "🔐 Ad-Hoc Signing JamfKiller for Distribution"
echo "============================================="

APP_NAME="JamfKiller"
APP_BUNDLE="${APP_NAME}.app"

# Check if app bundle exists
if [ ! -d "${APP_BUNDLE}" ]; then
    echo "❌ Error: ${APP_BUNDLE} not found. Run ./create_app.sh first."
    exit 1
fi

echo "🔏 Signing with ad-hoc signature..."

# Use ad-hoc signing (no certificate needed)
codesign --force --deep --sign - "${APP_BUNDLE}"

if [ $? -eq 0 ]; then
    echo "✅ App signed successfully with ad-hoc signature!"
    
    # Verify the signature
    echo "🔍 Verifying signature..."
    codesign --verify --verbose=2 "${APP_BUNDLE}"
    
    if [ $? -eq 0 ]; then
        echo "✅ Signature verified!"
        echo ""
        echo "🎉 Your app is now signed!"
        echo ""
        echo "📝 Next steps:"
        echo "   1. Create DMG: ./create_dmg.sh"
        echo "   2. Distribute the DMG"
        echo ""
        echo "💡 Users will need to:"
        echo "   - Right-click the app and select 'Open' the first time"
        echo "   - Click 'Open' when warned about unidentified developer"
        echo "   - After that, the app will open normally"
        echo ""
        echo "🔓 Alternative for users:"
        echo "   Remove quarantine: sudo xattr -rd com.apple.quarantine /Applications/JamfKiller.app"
    else
        echo "❌ Signature verification failed"
        exit 1
    fi
else
    echo "❌ Failed to sign the app"
    exit 1
fi 