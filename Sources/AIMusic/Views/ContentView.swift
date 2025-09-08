import SwiftUI

struct ContentView: View {
    @EnvironmentObject var audioEngine: AudioEngine
    @EnvironmentObject var musicGenerator: MusicGenerator
    @State private var isGenerating = false
    @State private var isPlaying = false
    @State private var selectedStyle = MusicStyle.ambient
    @State private var tempo: Double = 120
    @State private var duration: Double = 30
    @State private var generatedNotes: [Note] = []
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            HStack {
                Image(systemName: "music.note")
                    .font(.largeTitle)
                    .foregroundColor(.blue)
                Text("AI Music Generator")
                    .font(.largeTitle)
                    .fontWeight(.bold)
            }
            .padding(.top)
            
            // Controls
            VStack(spacing: 15) {
                // Style Selection
                VStack(alignment: .leading) {
                    Text("Music Style")
                        .font(.headline)
                    Picker("Style", selection: $selectedStyle) {
                        ForEach(MusicStyle.allCases, id: \.self) { style in
                            Text(style.rawValue.capitalized).tag(style)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                // Tempo Control
                VStack(alignment: .leading) {
                    Text("Tempo: \(Int(tempo)) BPM")
                        .font(.headline)
                    Slider(value: $tempo, in: 60...180, step: 5)
                }
                
                // Duration Control
                VStack(alignment: .leading) {
                    Text("Duration: \(Int(duration)) seconds")
                        .font(.headline)
                    Slider(value: $duration, in: 10...120, step: 5)
                }
            }
            .padding(.horizontal, 40)
            
            // Generate Button
            Button(action: generateMusic) {
                HStack {
                    if isGenerating {
                        ProgressView()
                            .scaleEffect(0.8)
                    } else {
                        Image(systemName: "wand.and.stars")
                    }
                    Text(isGenerating ? "Generating..." : "Generate Music")
                }
                .frame(width: 200, height: 40)
                .background(isGenerating ? Color.gray : Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .disabled(isGenerating)
            
            // Playback Controls
            if !generatedNotes.isEmpty {
                HStack(spacing: 20) {
                    Button(action: togglePlayback) {
                        Image(systemName: isPlaying ? "pause.circle.fill" : "play.circle.fill")
                            .font(.title)
                            .foregroundColor(.green)
                    }
                    
                    Button(action: stopPlayback) {
                        Image(systemName: "stop.circle.fill")
                            .font(.title)
                            .foregroundColor(.red)
                    }
                    
                    Button(action: exportMusic) {
                        HStack {
                            Image(systemName: "square.and.arrow.up")
                            Text("Export")
                        }
                        .padding(.horizontal, 15)
                        .padding(.vertical, 8)
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                }
                .padding()
            }
            
            // Visual Feedback
            if !generatedNotes.isEmpty {
                Text("Generated \(generatedNotes.count) notes")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                // Simple visualization
                HStack {
                    ForEach(Array(generatedNotes.prefix(20).enumerated()), id: \.offset) { index, note in
                        Rectangle()
                            .fill(Color.blue.opacity(0.7))
                            .frame(width: 8, height: CGFloat(note.velocity) * 50)
                            .cornerRadius(2)
                    }
                }
                .frame(height: 60)
                .padding()
            }
            
            Spacer()
        }
        .padding()
        .onAppear {
            audioEngine.start()
        }
    }
    
    private func generateMusic() {
        isGenerating = true
        
        Task {
            let parameters = GenerationParameters(
                style: selectedStyle,
                tempo: tempo,
                duration: duration
            )
            
            do {
                let notes = try await musicGenerator.generateMusic(parameters: parameters)
                await MainActor.run {
                    self.generatedNotes = notes
                    self.isGenerating = false
                }
            } catch {
                await MainActor.run {
                    self.isGenerating = false
                    print("Error generating music: \(error)")
                }
            }
        }
    }
    
    private func togglePlayback() {
        if isPlaying {
            audioEngine.pause()
        } else {
            audioEngine.play(notes: generatedNotes)
        }
        isPlaying.toggle()
    }
    
    private func stopPlayback() {
        audioEngine.stop()
        isPlaying = false
    }
    
    private func exportMusic() {
        // Export functionality would be implemented here
        print("Exporting music...")
    }
}