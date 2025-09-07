import Foundation

// MARK: - Music Style Enum
enum MusicStyle: String, CaseIterable {
    case ambient = "ambient"
    case classical = "classical"
    case electronic = "electronic"
    case jazz = "jazz"
    case rock = "rock"
    case cinematic = "cinematic"
}

// MARK: - Note Model
struct Note: Identifiable, Codable {
    let id = UUID()
    let pitch: Int // MIDI note number (0-127)
    let velocity: Double // 0.0 to 1.0
    let startTime: Double // in seconds
    let duration: Double // in seconds
    let octave: Int
    
    var frequency: Double {
        // Convert MIDI note to frequency
        return 440.0 * pow(2.0, Double(pitch - 69) / 12.0)
    }
    
    var noteName: String {
        let noteNames = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]
        let noteIndex = pitch % 12
        return "\(noteNames[noteIndex])\(octave)"
    }
}

// MARK: - Generation Parameters
struct GenerationParameters {
    let style: MusicStyle
    let tempo: Double
    let duration: Double
    let key: String
    let timeSignature: String
    
    init(style: MusicStyle, tempo: Double, duration: Double, key: String = "C", timeSignature: String = "4/4") {
        self.style = style
        self.tempo = tempo
        self.duration = duration
        self.key = key
        self.timeSignature = timeSignature
    }
}

// MARK: - Scale Definitions
struct Scale {
    static let major = [0, 2, 4, 5, 7, 9, 11]
    static let minor = [0, 2, 3, 5, 7, 8, 10]
    static let pentatonic = [0, 2, 4, 7, 9]
    static let blues = [0, 3, 5, 6, 7, 10]
    static let dorian = [0, 2, 3, 5, 7, 9, 10]
    static let mixolydian = [0, 2, 4, 5, 7, 9, 10]
    
    static func getScale(for style: MusicStyle) -> [Int] {
        switch style {
        case .ambient, .cinematic:
            return dorian
        case .classical:
            return major
        case .electronic:
            return minor
        case .jazz:
            return mixolydian
        case .rock:
            return pentatonic
        }
    }
}

// MARK: - Chord Progressions
struct ChordProgression {
    static func getProgression(for style: MusicStyle) -> [Int] {
        switch style {
        case .ambient:
            return [0, 3, 6, 4] // i, ♭III, ♭VI, iv
        case .classical:
            return [0, 5, 3, 4] // I, vi, IV, V
        case .electronic:
            return [0, 6, 3, 4] // i, ♭VI, ♭III, iv
        case .jazz:
            return [0, 3, 4, 5] // I, IV, V, vi
        case .rock:
            return [0, 5, 3, 4] // I, vi, IV, V
        case .cinematic:
            return [0, 4, 1, 5] // i, iv, ♭II, v
        }
    }
}