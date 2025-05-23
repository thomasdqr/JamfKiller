# 💀 JamfKiller - Ultra Kill Edition

A **stunning** native macOS app with a beautiful animated UI that provides **ultra-fast elimination** of annoying Jamf Connect popup windows.

![Platform](https://img.shields.io/badge/Platform-macOS%2014+-blue) ![Swift](https://img.shields.io/badge/Language-Swift-orange) ![SwiftUI](https://img.shields.io/badge/Framework-SwiftUI-purple)

## 🚀 Features

- **⚡ Ultra Kill Mode**: Monitors and eliminates Jamf processes every **0.1 seconds**
- **🎨 Beautiful Animated UI**: Modern dark theme with gradients, particle effects, and smooth animations
- **🎯 Big Toggle Button**: Giant, pulsing button to enable/disable ultra-kill mode
- **📊 Real-time Status**: Live process monitoring with kill count tracking
- **💀 Multiple Kill Methods**: Uses advanced detection and termination techniques
- **🔥 Zero Popup Flash**: Kills processes before they can show UI

## 🎨 Interface

The app features a **stunning visual design**:
- **Dynamic gradient backgrounds** that change when ultra-kill is active
- **Animated skulls** and particle systems
- **Pulsing giant toggle button** with glow effects
- **Real-time status cards** with smooth transitions
- **Kill counter** with animated updates

## 🛠 Installation & Setup

### Quick Start (Recommended)

1. **Clone and run:**
   ```bash
   git clone <your-repo-url>
   cd JamfKiller
   ./run.sh
   ```

2. **Or build and run:**
   ```bash
   ./build.sh
   ./.build/release/JamfKiller
   ```

### Development Mode

```bash
swift run
```

## 📦 Distribution & Sharing

### 🚀 Create Shareable DMG (One Command!)

Want to share JamfKiller with others? Create a professional, installable DMG:

```bash
# One-click release package
./package_for_release.sh
```

This creates `JamfKiller-v1.0.0.dmg` that you can share with anyone!

### 📤 Sharing Options

**Easy Distribution:**
- 📧 **Email** - Attach the DMG file directly
- 🌐 **GitHub Releases** - Upload for public download
- ☁️ **Cloud Storage** - Google Drive, Dropbox, etc.
- 💬 **Team Chat** - Slack, Teams, Discord

**Recipients just:**
1. Download `JamfKiller-v1.0.0.dmg`
2. Double-click to open
3. Drag JamfKiller.app → Applications
4. Launch and enjoy! 🎉

### 🔧 Advanced DMG Creation

For more control, use the detailed script:

```bash
# Detailed DMG creator with custom options
./create_dmg.sh
```

This creates a professional DMG with:
- ✅ **Drag-to-install interface**
- ✅ **Applications folder shortcut**
- ✅ **Installation instructions**
- ✅ **Compressed for smaller download**
- ✅ **Professional appearance**

## 🎯 Usage

### Ultra Kill Mode
1. **Launch JamfKiller** 
2. **Click the giant toggle button** to activate Ultra Kill Mode
3. **Watch as Jamf processes are eliminated** before they can show popups
4. **Monitor the kill count** in real-time
5. **Click again to disable** when needed

### What Happens When Active
- **Monitors every 0.1 seconds** for Jamf processes
- **Instantly terminates** detected processes
- **Updates the beautiful UI** with kill statistics
- **Prevents popup windows** from appearing
- **Shows dynamic visual feedback** 

## ⚙️ Technical Details

### Enhanced Detection
The app detects and eliminates:
- `JamfDaemon` - Main Jamf daemon
- `Jamf Connect` - Popup application
- `JamfAgent` - Background agent
- `JCDaemon` - Connect daemon
- All processes with "jamf" in the path

### Ultra-Fast Termination
- **0.1-second monitoring intervals**
- **Multiple kill methods**: `kill -9`, `killall`, process detection
- **Advanced process scanning** using shell commands
- **Immediate execution** on detection

### Permissions Required
- **Process termination rights** (for killing Jamf processes)
- **System process access** (may require approval on first run)

## 🎨 Beautiful UI Components

### Giant Toggle Button
- **200px diameter** with radial gradients
- **Pulsing animation** with glow effects
- **Color changes**: Red (inactive) → Orange (active)
- **Smooth press animations**

### Dynamic Background
- **Gradient transitions** based on ultra-kill state
- **Animated particle systems** (more particles when active)
- **Smooth color animations**

### Status Cards
- **Real-time status messages**
- **Animated kill counter**
- **Gradient borders** that change with state

## 💡 Pro Tips

- **Keep Ultra Kill Mode active** for continuous protection
- **Watch the particle effects** - they intensify when active
- **Monitor the kill count** to see how effective it is
- **The UI changes color** to show when ultra-kill is active

## 🚀 Project Structure

```
JamfKiller/
├── Package.swift           # Swift Package configuration
├── Sources/JamfKiller/
│   ├── JamfKillerApp.swift    # Main app entry point
│   ├── ContentView.swift      # Beautiful UI with animations
│   └── JamfKillerService.swift # Ultra-kill logic
├── jamf_killer_improved.sh   # Command-line version (reference)
├── build.sh                  # Build script
├── run.sh                    # Quick run script
└── README.md                 # This file
```

## 🔧 Building

### Swift Package (Current)
```bash
swift build --configuration release
```

### Run Development Version
```bash
swift run
```

## ⚠️ Important Notes

- **Requires macOS 14.0+** for SwiftUI features
- **No sandbox restrictions** - needed for process termination
- **May request permissions** on first run (allow them)
- **Ultra-fast monitoring** uses minimal CPU resources

## 🐛 Troubleshooting

**App won't kill processes?**
- Grant permissions when macOS prompts
- Check System Preferences → Security & Privacy

**Build fails?**
```bash
swift package clean
swift package resolve
swift build
```

**Permission issues?**
- Right-click app → Open (first time)
- Allow in Security & Privacy settings

## 🎯 How It Solves Your Problem

**Before JamfKiller:**
- ❌ Jamf popups appear and flash
- ❌ Manual killing required
- ❌ Popups restart quickly
- ❌ Annoying interruptions

**With JamfKiller Ultra Kill Mode:**
- ✅ **Zero popup flash** - killed before UI appears
- ✅ **Automatic monitoring** - no manual intervention
- ✅ **0.1-second response time** - ultra-fast elimination
- ✅ **Beautiful interface** - enjoy using it!

---

**Made with ❤️ and SwiftUI to eliminate those annoying Jamf popups forever! 💀⚡** 