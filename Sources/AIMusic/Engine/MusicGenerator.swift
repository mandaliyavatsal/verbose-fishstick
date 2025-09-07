import Foundation

@MainActor
class MusicGenerator: ObservableObject {
    @Published var isGenerating = false
    
    private let neuralWeights: [[Double]]
    private let randomSeed: UInt64
    
    init() {
        // Initialize simple neural network weights for music generation
        self.neuralWeights = MusicGenerator.generateNeuralWeights()
        self.randomSeed = UInt64.random(in: 0...UInt64.max)
    }
    
    func generateMusic(parameters: GenerationParameters) async throws -> [Note] {
        isGenerating = true
        defer { isGenerating = false }
        
        // Simulate processing time
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
        
        let scale = Scale.getScale(for: parameters.style)
        let progression = ChordProgression.getProgression(for: parameters.style)
        let beatsPerSecond = parameters.tempo / 60.0
        let totalBeats = beatsPerSecond * parameters.duration
        
        var notes: [Note] = []
        var currentTime: Double = 0.0
        let baseOctave = 4
        
        // Generate melody based on AI algorithm
        for beat in stride(from: 0, to: totalBeats, by: 0.25) {
            let beatTime = beat / beatsPerSecond
            
            if shouldGenerateNote(at: beat, style: parameters.style) {
                let scaleIndex = selectScaleNote(beat: beat, style: parameters.style, scale: scale)
                let octaveVariation = selectOctave(beat: beat, style: parameters.style)
                let pitch = 60 + scale[scaleIndex % scale.count] + (octaveVariation * 12) // Middle C + scale note
                let velocity = generateVelocity(beat: beat, style: parameters.style)
                let duration = generateNoteDuration(beat: beat, style: parameters.style, tempo: beatsPerSecond)
                
                let note = Note(
                    pitch: pitch,
                    velocity: velocity,
                    startTime: beatTime,
                    duration: duration,
                    octave: baseOctave + octaveVariation
                )
                
                notes.append(note)
            }
            
            currentTime = beatTime
        }
        
        // Generate harmony/chords
        let harmonyNotes = generateHarmony(
            progression: progression,
            scale: scale,
            duration: parameters.duration,
            tempo: parameters.tempo,
            style: parameters.style
        )
        
        notes.append(contentsOf: harmonyNotes)
        
        // Sort notes by start time
        notes.sort { $0.startTime < $1.startTime }
        
        return notes
    }
    
    private func shouldGenerateNote(at beat: Double, style: MusicStyle) -> Bool {
        let beatIndex = Int(beat * 4) // Convert to 16th note resolution
        let hash = hashFunction(beatIndex)
        
        let probability: Double = switch style {
        case .ambient: 0.3
        case .classical: 0.6
        case .electronic: 0.7
        case .jazz: 0.5
        case .rock: 0.8
        case .cinematic: 0.4
        }
        
        return Double(hash % 100) / 100.0 < probability
    }
    
    private func selectScaleNote(beat: Double, style: MusicStyle, scale: [Int]) -> Int {
        let beatIndex = Int(beat * 4)
        let hash = hashFunction(beatIndex + 1000)
        
        // Use neural network-like decision making
        let input = normalizeInput(beat: beat, style: style)
        let output = neuralForward(input: input)
        let scaleIndex = Int(output * Double(scale.count))
        
        return max(0, min(scale.count - 1, scaleIndex))
    }
    
    private func selectOctave(beat: Double, style: MusicStyle) -> Int {
        let beatIndex = Int(beat * 4)
        let hash = hashFunction(beatIndex + 2000)
        
        return switch style {
        case .ambient: (hash % 3) - 1 // -1, 0, 1
        case .classical: (hash % 4) - 1 // -1, 0, 1, 2
        case .electronic: (hash % 3) - 1
        case .jazz: (hash % 2) // 0, 1
        case .rock: (hash % 2) // 0, 1
        case .cinematic: (hash % 4) - 2 // -2, -1, 0, 1
        }
    }
    
    private func generateVelocity(beat: Double, style: MusicStyle) -> Double {
        let beatIndex = Int(beat * 4)
        let hash = hashFunction(beatIndex + 3000)
        let baseVelocity = Double(hash % 40 + 60) / 127.0 // 60-100 range
        
        return switch style {
        case .ambient: baseVelocity * 0.6 // Softer
        case .classical: baseVelocity * 0.8
        case .electronic: baseVelocity * 0.9
        case .jazz: baseVelocity * 0.7
        case .rock: baseVelocity * 1.0 // Full range
        case .cinematic: baseVelocity * 0.75
        }
    }
    
    private func generateNoteDuration(beat: Double, style: MusicStyle, tempo: Double) -> Double {
        let beatIndex = Int(beat * 4)
        let hash = hashFunction(beatIndex + 4000)
        let beatLength = 60.0 / tempo
        
        let multiplier: Double = switch hash % 4 {
        case 0: 0.25 // 16th note
        case 1: 0.5  // 8th note
        case 2: 1.0  // Quarter note
        case 3: 2.0  // Half note
        default: 1.0
        }
        
        return beatLength * multiplier * switch style {
        case .ambient: 2.0 // Longer notes
        case .classical: 1.0
        case .electronic: 0.5 // Shorter notes
        case .jazz: 1.2
        case .rock: 0.8
        case .cinematic: 1.5
        }
    }
    
    private func generateHarmony(progression: [Int], scale: [Int], duration: Double, tempo: Double, style: MusicStyle) -> [Note] {
        var harmonyNotes: [Note] = []
        let chordDuration = 60.0 / tempo * 4.0 // 4 beats per chord
        let numberOfChords = Int(duration / chordDuration)
        
        for chordIndex in 0..<numberOfChords {
            let startTime = Double(chordIndex) * chordDuration
            let rootNote = progression[chordIndex % progression.count]
            let rootPitch = 48 + scale[rootNote % scale.count] // Lower octave for bass
            
            // Root note
            harmonyNotes.append(Note(
                pitch: rootPitch,
                velocity: 0.5,
                startTime: startTime,
                duration: chordDuration,
                octave: 3
            ))
            
            // Third
            let thirdIndex = (rootNote + 2) % scale.count
            harmonyNotes.append(Note(
                pitch: rootPitch + scale[thirdIndex],
                velocity: 0.4,
                startTime: startTime,
                duration: chordDuration,
                octave: 3
            ))
            
            // Fifth
            let fifthIndex = (rootNote + 4) % scale.count
            harmonyNotes.append(Note(
                pitch: rootPitch + scale[fifthIndex],
                velocity: 0.4,
                startTime: startTime,
                duration: chordDuration,
                octave: 3
            ))
        }
        
        return harmonyNotes
    }
    
    // Simple neural network simulation
    private func normalizeInput(beat: Double, style: MusicStyle) -> [Double] {
        return [
            sin(beat * 0.1), // Rhythmic pattern
            cos(beat * 0.05), // Longer wave
            Double(style.hashValue) / 100.0, // Style influence
            (beat.truncatingRemainder(dividingBy: 4.0)) / 4.0 // Beat position in measure
        ]
    }
    
    private func neuralForward(input: [Double]) -> Double {
        guard input.count == neuralWeights.count else { return 0.5 }
        
        var output = 0.0
        for i in 0..<input.count {
            for j in 0..<neuralWeights[i].count {
                output += input[i] * neuralWeights[i][j]
            }
        }
        
        // Apply sigmoid activation
        return 1.0 / (1.0 + exp(-output))
    }
    
    private func hashFunction(_ input: Int) -> Int {
        var hash = input
        hash ^= hash >> 16
        hash &*= 0x85ebca6b
        hash ^= hash >> 13
        hash &*= 0xc2b2ae35
        hash ^= hash >> 16
        return abs(hash)
    }
    
    private static func generateNeuralWeights() -> [[Double]] {
        return (0..<4).map { _ in
            (0..<4).map { _ in Double.random(in: -1.0...1.0) }
        }
    }
}