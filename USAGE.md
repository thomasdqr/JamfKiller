# 🚀 JamfKiller Quick Start Guide

## What You Have Now

I've created a complete JamfKiller toolkit with multiple options for your Mac:

### 1. 💀 **jamf_killer.sh** - Ready-to-Run Bash Script
The main tool that works immediately without any setup or compilation.

**Features:**
- 🔍 Scan for Jamf processes
- 💀 Kill all Jamf processes on demand
- 🤖 Auto-monitor mode (runs in background)
- 🎨 Beautiful colored interface
- 📊 Process tracking and statistics

**Usage:**
```bash
./jamf_killer.sh
```

### 2. 🛠 **install.sh** - Easy Installer
Installs JamfKiller for system-wide use.

**Usage:**
```bash
./install.sh
```

Choose from:
- System-wide installation (`jamfkiller` command)
- User-only installation 
- Shell alias creation

### 3. 🎨 **SwiftUI App** (JamfKiller.xcodeproj)
Beautiful native macOS app with animations (requires Xcode).

**Features:**
- 🎯 Big red kill button with animations
- 🤖 Auto-kill toggle
- 📊 Real-time process monitoring
- ✨ Particle effects and smooth animations
- 📈 Kill statistics tracking

### 4. ⚡ **jamf_killer_simple.swift** - Swift Command Line
Swift-based command line tool with interactive menu.

## Quick Start (Recommended)

1. **Immediate Use:**
   ```bash
   ./jamf_killer.sh
   ```

2. **Install for Easy Access:**
   ```bash
   ./install.sh
   # Then run: jamfkiller
   ```

3. **Auto-Monitor Mode:**
   - Choose option 3 in the menu
   - Runs continuously in background
   - Automatically kills Jamf popups as they appear

## How It Works

The tool detects and terminates these Jamf processes:
- Jamf Connect (main popup)
- jamf, jamfAgent
- Jamf Connect Login/Notify
- JCPasswordChangeHelper
- And more...

### Kill Methods Used:
1. **Graceful termination** via NSWorkspace/AppleScript
2. **Process killing** via `pkill` and `kill`
3. **Force termination** via `killall -9`
4. **Application termination** via macOS APIs

## Permissions

The tool may request permissions for:
- **Process termination** (to kill Jamf processes)
- **Accessibility** (for system process access)

Click "Allow" when prompted by macOS.

## Pro Tips

- **Auto-monitor mode** is perfect for hands-off operation
- **Option 2** gives instant manual kill
- **Option 1** lets you see what's running before killing
- Run the installer once for system-wide access

## Troubleshooting

**Tool won't kill processes?**
- Grant permissions when macOS asks
- Check System Preferences → Security & Privacy

**Can't run the script?**
- Make sure it's executable: `chmod +x jamf_killer.sh`
- Run with: `./jamf_killer.sh`

**Want to build the beautiful SwiftUI app?**
- Open `JamfKiller.xcodeproj` in Xcode
- Press Cmd+R to build and run

---

**You're now armed and ready to fight annoying Jamf popups! 🎯💀** 