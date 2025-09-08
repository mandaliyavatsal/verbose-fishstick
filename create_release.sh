#!/bin/bash

# Release script for AI Music Generator
# This script creates a new release and triggers the build process

set -e

VERSION=${1:-"v1.0.0"}
RELEASE_NAME="AI Music Generator ${VERSION}"

echo "🚀 Creating release ${VERSION} for AI Music Generator"

# Validate we're on the right branch
CURRENT_BRANCH=$(git branch --show-current)
if [ "$CURRENT_BRANCH" != "main" ]; then
    echo "⚠️  Warning: You're not on the main branch (currently on: $CURRENT_BRANCH)"
    echo "   This script should typically be run from the main branch."
    read -p "   Continue anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Check for uncommitted changes
if ! git diff-index --quiet HEAD --; then
    echo "❌ Error: You have uncommitted changes. Please commit them first."
    exit 1
fi

# Create and push the tag
echo "🏷️  Creating tag ${VERSION}..."
git tag -a "${VERSION}" -m "Release ${VERSION}

${RELEASE_NAME}

This release includes:
- Native macOS AI music generation app
- Universal binary (Apple Silicon + Intel)
- 6 musical styles (Ambient, Classical, Electronic, Jazz, Rock, Cinematic)
- AudioKit integration for professional audio quality
- Real-time generation and playback
- Export functionality

Built automatically via GitHub Actions."

echo "📤 Pushing tag to GitHub..."
git push origin "${VERSION}"

echo "✅ Release process initiated!"
echo ""
echo "📋 Next steps:"
echo "   1. Go to https://github.com/$(git config --get remote.origin.url | sed 's|.*github.com[:/]\(.*\)\.git|\1|')/actions"
echo "   2. Wait for the build to complete (usually 5-10 minutes)"
echo "   3. Go to https://github.com/$(git config --get remote.origin.url | sed 's|.*github.com[:/]\(.*\)\.git|\1|')/releases"
echo "   4. Create a new release using tag ${VERSION}"
echo "   5. Upload the DMG from the GitHub Actions artifacts"
echo "   6. Publish the release"
echo ""
echo "🎵 The macOS app will be built automatically and available for download!"