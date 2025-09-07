#!/bin/bash

# Build script for AI Music Generator macOS app
# This script builds the app for Apple Silicon (arm64) and Intel (x86_64)

set -e

echo "🎵 Building AI Music Generator for macOS..."

# Clean previous builds
echo "Cleaning previous builds..."
rm -rf .build
rm -rf AIMusic.app

# Build for Apple Silicon (arm64)
echo "Building for Apple Silicon (arm64)..."
swift build --configuration release --arch arm64

# Build for Intel (x86_64) - for compatibility
echo "Building for Intel (x86_64)..."
swift build --configuration release --arch x86_64

# Create universal binary
echo "Creating universal binary..."
mkdir -p .build/universal
lipo -create \
    .build/arm64-apple-macosx/release/AIMusic \
    .build/x86_64-apple-macosx/release/AIMusic \
    -output .build/universal/AIMusic

# Create app bundle
echo "Creating app bundle..."
mkdir -p AIMusic.app/Contents/MacOS
mkdir -p AIMusic.app/Contents/Resources

# Copy binary
cp .build/universal/AIMusic AIMusic.app/Contents/MacOS/

# Copy Info.plist
cp Info.plist AIMusic.app/Contents/

# Create minimal Resources
echo "Creating app resources..."
cat > AIMusic.app/Contents/Resources/AppIcon.icns << 'EOF'
# This would be a proper .icns file in a real implementation
# For now, we'll create a placeholder
EOF

# Set executable permissions
chmod +x AIMusic.app/Contents/MacOS/AIMusic

echo "✅ Build complete!"
echo "📦 App bundle created at: $(pwd)/AIMusic.app"
echo ""
echo "To run the app:"
echo "  open AIMusic.app"
echo ""
echo "To create a distributable DMG:"
echo "  ./create_dmg.sh"