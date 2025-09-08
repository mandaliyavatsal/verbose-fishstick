#!/bin/bash

# DMG creation script for AI Music Generator
# Creates a distributable disk image for macOS

set -e

APP_NAME="AI Music Generator"
DMG_NAME="AIMusic-v1.0-macOS"
BUNDLE_NAME="AIMusic.app"

echo "📦 Creating DMG for $APP_NAME..."

# Check if app bundle exists
if [ ! -d "$BUNDLE_NAME" ]; then
    echo "❌ Error: $BUNDLE_NAME not found. Run ./build.sh first."
    exit 1
fi

# Create temporary directory for DMG contents
TMP_DIR=$(mktemp -d)
echo "Using temporary directory: $TMP_DIR"

# Copy app to temp directory
cp -R "$BUNDLE_NAME" "$TMP_DIR/"

# Create README for the DMG
cat > "$TMP_DIR/README.txt" << 'EOF'
AI Music Generator v1.0
========================

Thank you for downloading AI Music Generator!

INSTALLATION:
1. Drag "AIMusic.app" to your Applications folder
2. Open the app from Applications or Launchpad
3. Grant audio permissions when prompted

SYSTEM REQUIREMENTS:
- macOS 13.0 or later
- Apple Silicon (M1/M2) or Intel Mac
- Audio output device

FEATURES:
- Offline AI music generation
- Multiple music styles (Ambient, Classical, Electronic, Jazz, Rock, Cinematic)
- Real-time playback
- Customizable tempo and duration
- Export functionality

USAGE:
1. Select your preferred music style
2. Adjust tempo (60-180 BPM) and duration (10-120 seconds)
3. Click "Generate Music" to create AI-generated music
4. Use playback controls to listen to your creation
5. Export your music for sharing

TROUBLESHOOTING:
- If the app doesn't open, right-click and select "Open" to bypass Gatekeeper
- Ensure your system audio is not muted
- Try generating music with different styles if one doesn't work

For support, visit: https://github.com/mandaliyavatsal/verbose-fishstick

LICENSE: GNU Lesser General Public License v2.1
EOF

# Create Applications symlink for easy installation
ln -s /Applications "$TMP_DIR/Applications"

# Create the DMG
echo "Creating DMG..."
hdiutil create -volname "$APP_NAME" \
               -srcfolder "$TMP_DIR" \
               -ov \
               -format UDZO \
               "$DMG_NAME.dmg"

# Clean up
rm -rf "$TMP_DIR"

echo "✅ DMG created successfully: $DMG_NAME.dmg"
echo "📊 DMG size: $(du -h "$DMG_NAME.dmg" | cut -f1)"
echo ""
echo "🚀 Your app is ready for distribution!"
echo "Users can download and install by:"
echo "1. Opening the DMG file"
echo "2. Dragging AIMusic.app to Applications"
echo "3. Running the app from Applications"