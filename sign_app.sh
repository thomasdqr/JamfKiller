#!/bin/bash

echo "🔐 Self-Signing JamfKiller for Distribution"
echo "==========================================="

APP_NAME="JamfKiller"
APP_BUNDLE="${APP_NAME}.app"
CERT_NAME="JamfKiller Developer"

# Check if app bundle exists
if [ ! -d "${APP_BUNDLE}" ]; then
    echo "❌ Error: ${APP_BUNDLE} not found. Run ./create_app.sh first."
    exit 1
fi

echo "🔍 Checking for existing certificates..."

# Check if we already have a suitable certificate
if security find-identity -v -p codesigning | grep -q "${CERT_NAME}"; then
    echo "✅ Found existing certificate: ${CERT_NAME}"
else
    echo "📝 Creating self-signed certificate..."
    echo "   (You may be prompted for your password)"
    
    # Create certificate using openssl and import method
    cat > cert_config.txt << EOF
[req]
distinguished_name = req_distinguished_name
req_extensions = v3_req
prompt = no

[req_distinguished_name]
CN = ${CERT_NAME}
C = US
ST = CA
L = San Francisco
O = JamfKiller
OU = Development

[v3_req]
keyUsage = keyEncipherment, dataEncipherment, digitalSignature
extendedKeyUsage = codeSigning
EOF

    # Create the certificate and key
    openssl req -new -x509 -days 365 -nodes \
        -config cert_config.txt \
        -keyout jamfkiller.key \
        -out jamfkiller.crt

    # Create a PKCS12 bundle for easier import
    openssl pkcs12 -export -out jamfkiller.p12 -inkey jamfkiller.key -in jamfkiller.crt -passout pass:

    # Import to keychain
    security import jamfkiller.p12 -k ~/Library/Keychains/login.keychain-db -P "" -T /usr/bin/codesign
    
    # Clean up temp files
    rm -f cert_config.txt jamfkiller.key jamfkiller.crt jamfkiller.p12
    
    if [ $? -eq 0 ]; then
        echo "✅ Certificate created and imported successfully"
    else
        echo "❌ Failed to create/import certificate"
        exit 1
    fi
fi

echo "🔏 Signing the app bundle..."

# Sign the app with the self-signed certificate
codesign --force --deep --sign "${CERT_NAME}" "${APP_BUNDLE}"

if [ $? -eq 0 ]; then
    echo "✅ App signed successfully!"
    
    # Verify the signature
    echo "🔍 Verifying signature..."
    codesign --verify --verbose=2 "${APP_BUNDLE}"
    
    if [ $? -eq 0 ]; then
        echo "✅ Signature verified!"
        echo ""
        echo "🎉 Your app is now signed and should work on other machines!"
        echo ""
        echo "📝 Next steps:"
        echo "   1. Recreate the DMG: ./create_dmg.sh"
        echo "   2. Distribute the new DMG"
        echo ""
        echo "💡 Users may still need to:"
        echo "   - Right-click the app and select 'Open' the first time"
        echo "   - Or go to System Preferences > Security & Privacy to allow it"
    else
        echo "❌ Signature verification failed"
        exit 1
    fi
else
    echo "❌ Failed to sign the app"
    exit 1
fi 