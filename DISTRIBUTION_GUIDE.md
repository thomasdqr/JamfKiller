# JamfKiller Distribution Guide

## The Problem
When you share macOS apps without proper code signing, users get the error:
- **French**: "JamfKiller est endommagé" (JamfKiller is damaged)
- **English**: "JamfKiller is damaged and can't be opened"

This isn't actually damage - it's macOS Gatekeeper blocking unsigned apps for security.

## The Solution (FREE - No Developer Account Needed)

### For Developers (You)

1. **Build a signed version for distribution:**
   ```bash
   ./build_for_distribution.sh
   ```
   
   This script will:
   - Create a self-signed certificate
   - Build and sign your app
   - Create a distribution-ready DMG

2. **Share the new DMG file** - it will be named something like `JamfKiller-v1.0.0.dmg`

### For Users (Your Friends)

When users download and try to run your app:

#### Method 1: Right-Click Open (Recommended)
1. Download the DMG file
2. Open the DMG 
3. Drag JamfKiller.app to Applications
4. **Right-click** JamfKiller.app and select **"Open"**
5. Click **"Open"** when prompted about unidentified developer
6. App will now work normally forever!

#### Method 2: System Settings
1. Try to open the app normally (it will fail)
2. Go to **System Settings** > **Privacy & Security**
3. Scroll down to find "JamfKiller was blocked..."
4. Click **"Open Anyway"**

#### Method 3: Disable Gatekeeper Temporarily (Advanced Users)
```bash
# Disable gatekeeper temporarily
sudo spctl --master-disable

# Re-enable after installing (recommended)
sudo spctl --master-enable
```

## Why This Happens

- **Gatekeeper**: macOS security feature that blocks unsigned apps
- **Code Signing**: Apps need digital signatures to be trusted
- **Developer ID**: Apple charges $99/year for official certificates
- **Self-Signing**: Free alternative that works but requires user approval

## What We Did

1. **Self-signed certificate**: Created a free development certificate
2. **Code signing**: Signed the app with our certificate
3. **User education**: Provided clear instructions for users

## Files Created

- `sign_app.sh` - Signs an existing app bundle
- `build_for_distribution.sh` - Complete build and sign process
- `JamfKiller-v1.0.0.dmg` - Distribution-ready DMG

## Testing

Test your signed DMG on a different Mac or user account:
1. Download the DMG as if you were a user
2. Follow the user instructions above
3. Verify the app opens without "damaged" errors

## Alternative Solutions (If Above Doesn't Work)

### For Power Users: Remove Quarantine
```bash
# Remove quarantine attribute from downloaded app
sudo xattr -rd com.apple.quarantine /Applications/JamfKiller.app
```

### For Developers: Notarization (Requires Paid Account)
If you later get an Apple Developer account:
1. Sign with Developer ID certificate
2. Notarize with Apple
3. Staple the notarization
4. Apps will install without any user warnings

## Troubleshooting

**"Operation not permitted"**: User needs admin password for some operations

**"No such file"**: Make sure the app is actually in /Applications

**Still says "damaged"**: Try removing quarantine attribute:
```bash
xattr -d com.apple.quarantine /Applications/JamfKiller.app
```

**Certificate issues**: Delete and recreate:
```bash
security delete-identity -c "JamfKiller Developer"
./build_for_distribution.sh
``` 