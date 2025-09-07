#!/usr/bin/env python3
"""
AI Music Generation Demo
This script demonstrates the core algorithms used in the macOS app
Run: python3 demo.py
"""

import math
import random
import json
from typing import List, Dict, Any

class Note:
    def __init__(self, pitch: int, velocity: float, start_time: float, duration: float, octave: int):
        self.pitch = pitch
        self.velocity = velocity
        self.start_time = start_time
        self.duration = duration
        self.octave = octave
    
    @property
    def frequency(self) -> float:
        return 440.0 * (2.0 ** ((self.pitch - 69) / 12.0))
    
    @property
    def note_name(self) -> str:
        note_names = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]
        return f"{note_names[self.pitch % 12]}{self.octave}"
    
    def to_dict(self) -> Dict[str, Any]:
        return {
            "pitch": self.pitch,
            "velocity": self.velocity,
            "start_time": self.start_time,
            "duration": self.duration,
            "octave": self.octave,
            "note_name": self.note_name,
            "frequency": self.frequency
        }

class MusicGenerator:
    def __init__(self):
        # Music scales
        self.scales = {
            "major": [0, 2, 4, 5, 7, 9, 11],
            "minor": [0, 2, 3, 5, 7, 8, 10],
            "pentatonic": [0, 2, 4, 7, 9],
            "blues": [0, 3, 5, 6, 7, 10],
            "dorian": [0, 2, 3, 5, 7, 9, 10],
            "mixolydian": [0, 2, 4, 5, 7, 9, 10]
        }
        
        # Style configurations
        self.styles = {
            "ambient": {
                "scale": "dorian",
                "progression": [0, 3, 6, 4],
                "note_probability": 0.3,
                "velocity_range": (0.2, 0.6),
                "duration_multiplier": 2.0,
                "octave_range": (-1, 1)
            },
            "classical": {
                "scale": "major",
                "progression": [0, 5, 3, 4],
                "note_probability": 0.6,
                "velocity_range": (0.4, 0.8),
                "duration_multiplier": 1.0,
                "octave_range": (-1, 2)
            },
            "electronic": {
                "scale": "minor",
                "progression": [0, 6, 3, 4],
                "note_probability": 0.7,
                "velocity_range": (0.6, 0.9),
                "duration_multiplier": 0.5,
                "octave_range": (-1, 1)
            },
            "jazz": {
                "scale": "mixolydian",
                "progression": [0, 3, 4, 5],
                "note_probability": 0.5,
                "velocity_range": (0.4, 0.7),
                "duration_multiplier": 1.2,
                "octave_range": (0, 1)
            },
            "rock": {
                "scale": "pentatonic",
                "progression": [0, 5, 3, 4],
                "note_probability": 0.8,
                "velocity_range": (0.7, 1.0),
                "duration_multiplier": 0.8,
                "octave_range": (0, 1)
            },
            "cinematic": {
                "scale": "dorian",
                "progression": [0, 4, 1, 5],
                "note_probability": 0.4,
                "velocity_range": (0.3, 0.75),
                "duration_multiplier": 1.5,
                "octave_range": (-2, 1)
            }
        }
        
        # Simple neural network weights
        self.neural_weights = [[random.uniform(-1, 1) for _ in range(4)] for _ in range(4)]
    
    def hash_function(self, input_val: int) -> int:
        """Simple hash function for deterministic randomness"""
        hash_val = input_val
        hash_val ^= hash_val >> 16
        hash_val *= 0x85ebca6b
        hash_val ^= hash_val >> 13
        hash_val *= 0xc2b2ae35
        hash_val ^= hash_val >> 16
        return abs(hash_val)
    
    def neural_forward(self, input_vals: List[float]) -> float:
        """Simple neural network simulation"""
        if len(input_vals) != len(self.neural_weights):
            return 0.5
        
        output = 0.0
        for i, input_val in enumerate(input_vals):
            for j, weight in enumerate(self.neural_weights[i]):
                output += input_val * weight
        
        # Sigmoid activation with overflow protection
        output = max(-500, min(500, output))  # Clamp to prevent overflow
        return 1.0 / (1.0 + math.exp(-output))
    
    def should_generate_note(self, beat: float, style: str) -> bool:
        """Determine if a note should be generated at this beat"""
        beat_index = int(beat * 4)  # 16th note resolution
        hash_val = self.hash_function(beat_index)
        probability = self.styles[style]["note_probability"]
        return (hash_val % 100) / 100.0 < probability
    
    def select_scale_note(self, beat: float, style: str) -> int:
        """Select a scale note using neural network"""
        scale_name = self.styles[style]["scale"]
        scale = self.scales[scale_name]
        
        # Neural network input
        input_vals = [
            math.sin(beat * 0.1),  # Rhythmic pattern
            math.cos(beat * 0.05),  # Longer wave
            hash(style) / 1000.0,  # Style influence
            (beat % 4.0) / 4.0  # Beat position in measure
        ]
        
        output = self.neural_forward(input_vals)
        scale_index = int(output * len(scale))
        return max(0, min(len(scale) - 1, scale_index))
    
    def generate_music(self, style: str = "ambient", tempo: float = 120, duration: float = 30) -> List[Note]:
        """Generate music with AI algorithms"""
        style_config = self.styles[style]
        scale_name = style_config["scale"]
        scale = self.scales[scale_name]
        
        beats_per_second = tempo / 60.0
        total_beats = beats_per_second * duration
        
        notes = []
        base_octave = 4
        
        print(f"🎵 Generating {style} music...")
        print(f"   Tempo: {tempo} BPM")
        print(f"   Duration: {duration} seconds")
        print(f"   Scale: {scale_name}")
        print(f"   Total beats: {total_beats:.1f}")
        
        # Generate melody
        for beat in [i * 0.25 for i in range(int(total_beats * 4))]:
            if self.should_generate_note(beat, style):
                beat_time = beat / beats_per_second
                
                # Select note from scale
                scale_index = self.select_scale_note(beat, style)
                
                # Select octave variation
                octave_min, octave_max = style_config["octave_range"]
                beat_index = int(beat * 4)
                hash_val = self.hash_function(beat_index + 2000)
                octave_variation = (hash_val % (octave_max - octave_min + 1)) + octave_min
                
                # Calculate pitch (Middle C = 60)
                pitch = 60 + scale[scale_index] + (octave_variation * 12)
                
                # Generate velocity
                vel_min, vel_max = style_config["velocity_range"]
                hash_val = self.hash_function(beat_index + 3000)
                velocity = vel_min + ((hash_val % 100) / 100.0) * (vel_max - vel_min)
                
                # Generate duration
                beat_length = 60.0 / tempo
                hash_val = self.hash_function(beat_index + 4000)
                duration_options = [0.25, 0.5, 1.0, 2.0]
                duration_multiplier = duration_options[hash_val % len(duration_options)]
                note_duration = beat_length * duration_multiplier * style_config["duration_multiplier"]
                
                note = Note(
                    pitch=pitch,
                    velocity=velocity,
                    start_time=beat_time,
                    duration=note_duration,
                    octave=base_octave + octave_variation
                )
                
                notes.append(note)
        
        # Generate harmony (simplified)
        progression = style_config["progression"]
        chord_duration = 60.0 / tempo * 4.0  # 4 beats per chord
        num_chords = int(duration / chord_duration)
        
        print(f"   Generated {len(notes)} melody notes")
        print(f"   Adding {num_chords} harmony chords")
        
        for chord_index in range(num_chords):
            start_time = chord_index * chord_duration
            root_note = progression[chord_index % len(progression)]
            root_pitch = 48 + scale[root_note % len(scale)]  # Lower octave for bass
            
            # Add chord notes (root, third, fifth)
            chord_notes = [0, 2, 4]  # Scale degrees
            for i, degree in enumerate(chord_notes):
                chord_pitch = root_pitch + scale[(root_note + degree) % len(scale)]
                velocity = 0.3 + (i * 0.1)  # Softer for harmony
                
                harmony_note = Note(
                    pitch=chord_pitch,
                    velocity=velocity,
                    start_time=start_time,
                    duration=chord_duration,
                    octave=3
                )
                notes.append(harmony_note)
        
        # Sort by start time
        notes.sort(key=lambda n: n.start_time)
        
        print(f"✅ Generated {len(notes)} total notes")
        return notes

def main():
    """Demo the AI music generation"""
    print("🎼 AI Music Generator Demo")
    print("=" * 40)
    
    generator = MusicGenerator()
    
    # Generate music in different styles
    styles = ["ambient", "classical", "electronic", "jazz", "rock", "cinematic"]
    
    for style in styles:
        print(f"\n🎨 Style: {style.upper()}")
        print("-" * 30)
        
        notes = generator.generate_music(style=style, tempo=120, duration=10)
        
        # Show first few notes
        print(f"\nFirst 5 notes:")
        for i, note in enumerate(notes[:5]):
            print(f"  {i+1}. {note.note_name} at {note.start_time:.2f}s "
                  f"(vel: {note.velocity:.2f}, dur: {note.duration:.2f}s)")
        
        # Save to JSON for analysis
        filename = f"demo_output_{style}.json"
        output_data = {
            "style": style,
            "tempo": 120,
            "duration": 10,
            "note_count": len(notes),
            "notes": [note.to_dict() for note in notes]
        }
        
        with open(filename, 'w') as f:
            json.dump(output_data, f, indent=2)
        
        print(f"💾 Saved to {filename}")
    
    print(f"\n🎯 Demo complete! Generated music in {len(styles)} styles.")
    print("📁 Check the .json files for detailed note data.")
    print("🔄 In the real macOS app, this data becomes live audio!")

if __name__ == "__main__":
    main()