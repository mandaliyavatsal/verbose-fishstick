# AI Music Generator for macOS

A native macOS application that generates music using artificial intelligence algorithms, optimized for Apple Silicon devices.

## Features

🎵 **Offline AI Music Generation** - No internet connection required  
🎨 **Multiple Music Styles** - Ambient, Classical, Electronic, Jazz, Rock, and Cinematic  
⚡ **Apple Silicon Optimized** - Native performance on M1/M2 Macs  
🎛️ **Customizable Parameters** - Adjust tempo (60-180 BPM) and duration (10-120 seconds)  
🔊 **Real-time Playback** - Instant audio feedback with professional quality  
💾 **Export Functionality** - Save your generated music  

## System Requirements

- **macOS**: 13.0 or later
- **Architecture**: Apple Silicon (M1/M2) or Intel x86_64
- **Audio**: Any audio output device
- **Storage**: ~50MB free space

## Installation

### Option 1: Download Pre-built App (Recommended)
1. Download the latest DMG from the releases section
2. Open the DMG file
3. Drag "AIMusic.app" to your Applications folder
4. Launch from Applications or Spotlight

### Option 2: Build from Source

#### Prerequisites
- Xcode 15.0 or later
- Swift 5.9 or later
- macOS 13.0 or later

#### Build Steps
```bash
# Clone the repository
git clone https://github.com/mandaliyavatsal/verbose-fishstick.git
cd verbose-fishstick

# Build the application
./build.sh

# Create distributable DMG (optional)
./create_dmg.sh
```

## Usage

1. **Launch the App**: Open AI Music Generator from Applications
2. **Select Style**: Choose from 6 different musical styles
3. **Set Parameters**: 
   - Adjust tempo slider (60-180 BPM)
   - Set duration (10-120 seconds)
4. **Generate**: Click "Generate Music" and wait for AI processing
5. **Listen**: Use playback controls to play/pause/stop
6. **Export**: Save your creation for sharing

## Music Styles

| Style | Description | Characteristics |
|-------|-------------|-----------------|
| **Ambient** | Atmospheric, meditative | Soft dynamics, longer notes, ethereal |
| **Classical** | Traditional orchestral | Structured harmonies, varied dynamics |
| **Electronic** | Modern synthetic sounds | Rhythmic patterns, electronic timbres |
| **Jazz** | Improvisational and complex | Swing rhythms, extended harmonies |
| **Rock** | Energetic and powerful | Strong beats, power chords |
| **Cinematic** | Dramatic and emotional | Wide dynamics, emotional progressions |

## AI Algorithm

The music generation uses a hybrid approach combining:

- **Neural Network Simulation**: Weighted decision making for note selection
- **Music Theory**: Scale-based harmony and chord progressions
- **Algorithmic Composition**: Deterministic patterns with controlled randomness
- **Style-specific Parameters**: Each genre has unique characteristics

### Technical Details

- **Polyphonic Generation**: Supports melody and harmony simultaneously
- **Real-time Synthesis**: Uses AudioKit for professional audio quality
- **MIDI Compatible**: Internal representation uses MIDI note format
- **Offline Processing**: All computation happens locally on your device

## Architecture

```
AIMusic.app/
├── ContentView.swift          # Main user interface
├── MusicGenerator.swift       # AI music generation engine
├── AudioEngine.swift         # Audio playback and synthesis
├── MusicModels.swift         # Data structures and music theory
└── Supporting Files/         # Configuration and resources
```

## Privacy & Security

- **No Network Access**: Completely offline operation
- **No Data Collection**: No user data is transmitted or stored externally
- **Local Processing**: All AI computation happens on your device
- **Audio Permissions**: Only requires audio output permissions

## Troubleshooting

### App Won't Open
- Right-click the app and select "Open" to bypass Gatekeeper
- Ensure you're running macOS 13.0 or later
- Try moving the app to Applications folder

### No Audio Output
- Check system audio settings and volume
- Ensure audio device is connected and working
- Grant audio permissions in System Preferences

### Performance Issues
- Close other audio applications
- Ensure sufficient free memory (>1GB recommended)
- Try shorter generation durations

## Development

### Project Structure
```
Sources/
├── AIMusic/
│   ├── AIMusicApp.swift       # App entry point
│   ├── Views/
│   │   └── ContentView.swift  # Main UI
│   ├── Models/
│   │   └── MusicModels.swift  # Data structures
│   └── Engine/
│       ├── MusicGenerator.swift # AI engine
│       └── AudioEngine.swift   # Audio system
```

### Dependencies
- **AudioKit**: Professional audio synthesis and processing
- **SoundpipeAudioKit**: Additional audio effects and generators
- **SwiftUI**: Native macOS user interface
- **Foundation**: Core system frameworks

### Building for Distribution

1. **Code Signing**: Required for App Store or Gatekeeper compatibility
2. **Notarization**: Apple's security verification process
3. **Universal Binary**: Supports both Apple Silicon and Intel Macs

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the GNU Lesser General Public License v2.1. See [LICENSE](LICENSE) for details.

## Acknowledgments

- **AudioKit**: For providing excellent audio framework
- **Apple**: For Swift and native macOS development tools
- **Open Source Community**: For inspiration and libraries

## Support

- **Issues**: Report bugs on GitHub Issues
- **Discussions**: Join community discussions
- **Documentation**: Check the wiki for detailed guides

---

**Made with ❤️ for the music and AI community**

*Generate infinite musical possibilities with the power of artificial intelligence, running natively on your Mac.*