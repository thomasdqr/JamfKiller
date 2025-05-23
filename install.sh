#!/bin/bash

echo "💀 Installing JamfKiller to Applications..."

# Create the app bundle
./create_app.sh

# Check if app was created successfully
if [ ! -d "JamfKiller.app" ]; then
    echo "❌ Failed to create app bundle"
    exit 1
fi

# Install to Applications
echo "📱 Installing to /Applications..."
sudo cp -r JamfKiller.app /Applications/

# Check if installation was successful
if [ -d "/Applications/JamfKiller.app" ]; then
    echo "✅ Successfully installed!"
    echo ""
    echo "🎯 JamfKiller is now installed in Applications"
    echo "💀 You can now launch it by:"
    echo "   - Opening Spotlight (Cmd+Space) and typing 'Jamf Killer'"
    echo "   - Going to Applications folder and double-clicking"
    echo "   - Running: open /Applications/JamfKiller.app"
    echo ""
    echo "🚀 Launch now? (y/n)"
    read -r launch_now
    if [[ "$launch_now" == "y" || "$launch_now" == "Y" ]]; then
        echo "🎉 Launching JamfKiller..."
        open /Applications/JamfKiller.app
    fi
else
    echo "❌ Installation failed"
    exit 1
fi 