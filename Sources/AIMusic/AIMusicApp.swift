import SwiftUI
import AudioKit
import SoundpipeAudioKit

@main
struct AIMusicApp: App {
    @StateObject private var audioEngine = AudioEngine()
    @StateObject private var musicGenerator = MusicGenerator()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(audioEngine)
                .environmentObject(musicGenerator)
                .frame(minWidth: 800, minHeight: 600)
        }
        .windowStyle(.titleBar)
        .windowResizability(.contentSize)
    }
}