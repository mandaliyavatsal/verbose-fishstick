// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "AIMusic",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(
            name: "AIMusic",
            targets: ["AIMusic"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/AudioKit/AudioKit", from: "5.6.0"),
        .package(url: "https://github.com/AudioKit/SoundpipeAudioKit", from: "5.6.0")
    ],
    targets: [
        .executableTarget(
            name: "AIMusic",
            dependencies: [
                "AudioKit",
                "SoundpipeAudioKit"
            ],
            path: "Sources"
        )
    ]
)