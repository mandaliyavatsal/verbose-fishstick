# 🚀 Release Creation Guide

This guide explains how to create and publish the first release of the AI Music Generator macOS app.

## Overview

The app is designed to be built automatically via GitHub Actions on macOS runners, since it requires macOS-specific frameworks (AudioKit, AudioToolbox) that are not available on Linux systems.

## Quick Release (Automated)

### Option 1: Using the Release Script

1. **Run the release script:**
   ```bash
   ./create_release.sh v1.0.0
   ```

2. **Monitor the build:**
   - Go to [GitHub Actions](../../actions)
   - Wait for the build to complete (5-10 minutes)

3. **Create the release:**
   - Go to [Releases](../../releases)
   - Click "Create a new release"
   - Use tag `v1.0.0`
   - Copy content from `RELEASE_NOTES.md`
   - Upload the DMG from GitHub Actions artifacts
   - Publish the release

### Option 2: Manual Tag Creation

1. **Create and push a tag:**
   ```bash
   git tag -a v1.0.0 -m "First release of AI Music Generator"
   git push origin v1.0.0
   ```

2. **Follow steps 2-3 from Option 1**

## Manual Build (Local macOS)

If you're on a Mac and want to build locally:

### Prerequisites

- macOS 13.0+ (Ventura or later)
- Xcode 14+ with Command Line Tools
- Swift 5.9+

### Build Steps

1. **Clone and build:**
   ```bash
   git clone https://github.com/mandaliyavatsal/verbose-fishstick.git
   cd verbose-fishstick
   ./build.sh
   ```

2. **Create distributable DMG:**
   ```bash
   ./create_dmg.sh
   ```

3. **Test the app:**
   ```bash
   open AIMusic.app
   ```

## Build Verification

### Test the Demo Script

Before releasing, verify the AI algorithms work:

```bash
python3 demo.py
```

Expected output:
- Generates music in 6 styles (Ambient, Classical, Electronic, Jazz, Rock, Cinematic)
- Creates JSON files with note data
- Shows different characteristics per style

### Test the macOS App

1. **Launch the app:**
   ```bash
   open AIMusic.app
   ```

2. **Verify features:**
   - [ ] App launches without errors
   - [ ] UI displays correctly
   - [ ] Can select different music styles
   - [ ] Can adjust tempo (60-180 BPM)
   - [ ] Can adjust duration (10-120 seconds)
   - [ ] "Generate Music" button works
   - [ ] Audio playback functions
   - [ ] Export functionality works

## Release Artifacts

The successful build will create:

1. **AIMusic.app** - The macOS application bundle
2. **AIMusic-v1.0-macOS.dmg** - Distributable disk image
3. **Build logs** - Available in GitHub Actions

## Troubleshooting

### Build Fails on AudioKit Dependencies

This is expected on non-macOS systems. The app requires:
- AudioToolbox framework (macOS only)
- Core Audio (macOS only)
- Metal/MetalKit for audio processing (macOS only)

**Solution:** Use GitHub Actions which runs on macOS runners.

### DMG Creation Fails

1. **Check app bundle exists:**
   ```bash
   ls -la AIMusic.app
   ```

2. **Verify permissions:**
   ```bash
   chmod +x AIMusic.app/Contents/MacOS/AIMusic
   ```

3. **Run create_dmg.sh manually:**
   ```bash
   ./create_dmg.sh
   ```

### Release Upload Issues

1. **Check artifact size:**
   ```bash
   du -h *.dmg
   ```

2. **Verify DMG integrity:**
   ```bash
   hdiutil verify AIMusic-v1.0-macOS.dmg
   ```

## Distribution

Once released, users can:

1. **Download** the DMG from GitHub Releases
2. **Install** by dragging to Applications folder
3. **Run** from Applications or Launchpad

### System Requirements

- macOS 13.0+ (Ventura or later)
- Apple Silicon (M1/M2/M3) or Intel Mac (2017+)
- ~50MB storage space
- Audio output device

## Next Steps

After successful release:

1. **Update README.md** with download links
2. **Test installation** on different Mac configurations
3. **Gather user feedback** for future improvements
4. **Plan v1.1** with additional features

---

🎵 **Ready to release!** The AI Music Generator is a fully functional macOS app that creates infinite variations of AI-generated music offline.