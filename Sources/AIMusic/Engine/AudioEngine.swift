import Foundation
import AudioKit
import SoundpipeAudioKit
import AVFoundation

@MainActor
class AudioEngine: ObservableObject {
    private var engine = AudioEngine()
    private var oscillatorBank: OscillatorBank?
    private var mixer: Mixer?
    private var reverb: Reverb?
    private var currentNotes: [Note] = []
    private var playbackTimer: Timer?
    private var startTime: Date?
    
    @Published var isPlaying = false
    @Published var currentTime: Double = 0.0
    
    init() {
        setupAudioEngine()
    }
    
    private func setupAudioEngine() {
        // Create oscillator bank for polyphonic synthesis
        oscillatorBank = OscillatorBank(waveform: Table(.sine))
        
        // Add effects
        reverb = Reverb(oscillatorBank!)
        reverb?.loadFactoryPreset(.mediumHall)
        reverb?.dryWetMix = 0.3
        
        mixer = Mixer(reverb!)
        
        // Set up the audio engine
        engine.output = mixer
        
        do {
            try engine.start()
        } catch {
            print("Failed to start audio engine: \(error)")
        }
    }
    
    func start() {
        do {
            try engine.start()
        } catch {
            print("Error starting audio engine: \(error)")
        }
    }
    
    func stop() {
        stopPlayback()
        engine.stop()
    }
    
    func play(notes: [Note]) {
        guard !notes.isEmpty else { return }
        
        currentNotes = notes.sorted { $0.startTime < $1.startTime }
        startTime = Date()
        isPlaying = true
        currentTime = 0.0
        
        // Start playback timer
        playbackTimer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { [weak self] _ in
            self?.updatePlayback()
        }
        
        scheduleNotes()
    }
    
    func pause() {
        isPlaying = false
        playbackTimer?.invalidate()
        oscillatorBank?.stop()
    }
    
    func stopPlayback() {
        isPlaying = false
        playbackTimer?.invalidate()
        playbackTimer = nil
        oscillatorBank?.stop()
        currentTime = 0.0
        startTime = nil
    }
    
    private func updatePlayback() {
        guard let startTime = startTime else { return }
        
        currentTime = Date().timeIntervalSince(startTime)
        
        // Check if playback is complete
        if let lastNote = currentNotes.last {
            let endTime = lastNote.startTime + lastNote.duration
            if currentTime >= endTime {
                stopPlayback()
            }
        }
    }
    
    private func scheduleNotes() {
        guard let oscillatorBank = oscillatorBank else { return }
        
        for note in currentNotes {
            DispatchQueue.main.asyncAfter(deadline: .now() + note.startTime) { [weak self] in
                guard self?.isPlaying == true else { return }
                
                // Play note
                oscillatorBank.play(
                    noteNumber: MIDINoteNumber(note.pitch),
                    velocity: MIDIVelocity(note.velocity * 127),
                    channel: 0
                )
                
                // Schedule note off
                DispatchQueue.main.asyncAfter(deadline: .now() + note.duration) {
                    oscillatorBank.stop(noteNumber: MIDINoteNumber(note.pitch), channel: 0)
                }
            }
        }
    }
    
    func exportToMIDI(notes: [Note], filename: String) -> URL? {
        // Create a simple MIDI file export
        let documentsPath = FileManager.default.urls(for: .documentsDirectory, in: .userDomainMask).first!
        let midiURL = documentsPath.appendingPathComponent("\(filename).mid")
        
        // This is a simplified MIDI export - in a real implementation,
        // you would use a proper MIDI library
        do {
            let midiData = createMIDIData(from: notes)
            try midiData.write(to: midiURL)
            return midiURL
        } catch {
            print("Error exporting MIDI: \(error)")
            return nil
        }
    }
    
    private func createMIDIData(from notes: [Note]) -> Data {
        // Simplified MIDI file creation
        // In a real implementation, you would use a proper MIDI library
        var data = Data()
        
        // MIDI header
        data.append(contentsOf: [0x4D, 0x54, 0x68, 0x64]) // "MThd"
        data.append(contentsOf: [0x00, 0x00, 0x00, 0x06]) // Header length
        data.append(contentsOf: [0x00, 0x00]) // Format type 0
        data.append(contentsOf: [0x00, 0x01]) // Number of tracks
        data.append(contentsOf: [0x01, 0xE0]) // Ticks per quarter note (480)
        
        // Track header
        data.append(contentsOf: [0x4D, 0x54, 0x72, 0x6B]) // "MTrk"
        
        // This is a placeholder - real MIDI encoding would be more complex
        let trackData = Data([0x00, 0xFF, 0x2F, 0x00]) // End of track
        let trackLength = UInt32(trackData.count).bigEndian
        data.append(Data(bytes: &trackLength, count: 4))
        data.append(trackData)
        
        return data
    }
}