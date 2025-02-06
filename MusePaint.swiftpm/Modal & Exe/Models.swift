//
//  Note.swift
//  MusePaint
//
//  Created by Prince Yadav on 03/02/25.
//

import SwiftUI
import AVFoundation

// MARK: - Data Models
struct Note {
    var pitch: Int
    var color: Color
    var position: CGPoint
    var size: CGFloat
    var instrument: Instrument
    var effect: Effect
    var visualEffect: VisualEffect
    let id = UUID()
}

struct Stroke: Identifiable {
    let id = UUID()
    var path: Path
    var color: Color
    var instrument: Instrument
    var lineWidth: CGFloat
}

// MARK: - Enums
enum Instrument: String, CaseIterable {
    case none = "None"
    case piano = "Piano"
    case violin = "Violin"
    case flute = "Flute"
    case guitar = "Guitar"
    case trumpet = "Trumpet"
    case marimba = "Marimba"
    case musicBox = "Music Box"
    
    var programNumber: UInt8 {
        switch self {
        case .none: return 1
        case .piano: return 0
        case .violin: return 40
        case .flute: return 73
        case .guitar: return 24
        case .trumpet: return 56
        case .marimba: return 12
        case .musicBox: return 10
        }
    }
    
    var wavFileURL: URL? {
        switch self {
        case .none:
            return nil
        default:
            let filename = self.rawValue.lowercased().replacingOccurrences(of: " ", with: "")
            return Bundle.main.url(forResource: filename, withExtension: "wav")
        }
    }
}

enum Effect: String, CaseIterable {
    case none = "None"
    case echo = "Echo"
    case sparkle = "Sparkle"
    case wave = "Wave"
    case cascade = "Cascade"
    case harmony = "Harmony"
    case arpeggio = "Arpeggio"
}

enum VisualEffect: String, CaseIterable {
    case none = "None"
    case ripple = "Ripple"
    case starburst = "Starburst"
    case shimmer = "Shimmer"
    case pulse = "Pulse"
    case orbit = "Orbit"
}

// MARK: - View Models
class MusicPaintingState: ObservableObject {
    @Published var notes: [Note] = []
    @Published var currentColor: Color = .blue
    @Published var currentPitch: Int = 60
    @Published var currentInstrument: Instrument = .piano
    @Published var currentEffect: Effect = .none
    @Published var currentVisualEffect: VisualEffect = .none
    @Published var isPlaying: Bool = false
    @Published var brushSize: CGFloat = 30
    @Published var tempo: Double = 1.0
    @Published var reverbAmount: Double = 50
    
    private var audioEngine: AVAudioEngine?
    private var synthesizer: AVAudioUnitSampler?
    private var reverb: AVAudioUnitReverb?
    private var delay: AVAudioUnitDelay?
    private let synthesizerQueue = DispatchQueue(label: "com.app.synthesizerQueue")
    private let compositionQueue = DispatchQueue(label: "com.app.compositionQueue")
    
    init() {
        setupAudio()
    }
    
    private func setupAudio() {
        audioEngine = AVAudioEngine()
        synthesizer = AVAudioUnitSampler()
        reverb = AVAudioUnitReverb()
        delay = AVAudioUnitDelay()
        
        guard let audioEngine = audioEngine,
              let synthesizer = synthesizer,
              let reverb = reverb,
              let delay = delay else { return }
        
        audioEngine.attach(synthesizer)
        audioEngine.attach(reverb)
        audioEngine.attach(delay)
        
        audioEngine.connect(synthesizer, to: delay, format: nil)
        audioEngine.connect(delay, to: reverb, format: nil)
        audioEngine.connect(reverb, to: audioEngine.mainMixerNode, format: nil)
        
        reverb.loadFactoryPreset(.largeHall)
        reverb.wetDryMix = Float(reverbAmount)
        
        delay.delayTime = 0.2
        delay.feedback = 30
        delay.wetDryMix = 40
        
        if let soundURL = currentInstrument.wavFileURL {
            try? synthesizer.loadInstrument(at: soundURL)
        }
        
        do {
            try audioEngine.start()
        } catch {
            print("Audio engine failed to start: \(error.localizedDescription)")
        }
    }
    
    func playNote(note: Note) {
        if let soundURL = note.instrument.wavFileURL {
            try? synthesizer?.loadInstrument(at: soundURL)
        }
        
        synthesizerQueue.async { [weak self] in
            guard let self = self else { return }
            self.synthesizer?.startNote(UInt8(note.pitch), withVelocity: 64, onChannel: 0)
            
            // Apply effects
            self.applyEffect(note: note)
            
            // Stop the note after duration
            self.synthesizerQueue.asyncAfter(deadline: .now() + 0.5) {
                self.synthesizer?.stopNote(UInt8(note.pitch), onChannel: 0)
            }
        }
    }
    
    private func applyEffect(note: Note) {
        switch note.effect {
        case .echo:
            synthesizerQueue.asyncAfter(deadline: .now() + 0.2) { [weak self] in
                self?.synthesizer?.startNote(UInt8(note.pitch), withVelocity: 32, onChannel: 0)
            }
        case .sparkle:
            synthesizerQueue.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                self?.synthesizer?.startNote(UInt8(note.pitch + 12), withVelocity: 32, onChannel: 0)
            }
        case .cascade:
            for i in 0...3 {
                synthesizerQueue.asyncAfter(deadline: .now() + Double(i) * 0.15) { [weak self] in
                    self?.synthesizer?.startNote(UInt8(note.pitch + i * 4), withVelocity: 64 - UInt8(i * 10), onChannel: 0)
                }
            }
        case .harmony:
            let harmonics = [0, 4, 7] // Major chord
            for harmonic in harmonics {
                self.synthesizer?.startNote(UInt8(note.pitch + harmonic), withVelocity: 48, onChannel: 0)
            }
        case .arpeggio:
            let notes = [0, 4, 7, 12] // Major arpeggio
            for (index, interval) in notes.enumerated() {
                synthesizerQueue.asyncAfter(deadline: .now() + Double(index) * 0.1) { [weak self] in
                    self?.synthesizer?.startNote(UInt8(note.pitch + interval), withVelocity: 48, onChannel: 0)
                }
            }
        default:
            break
        }
    }
    
    func addNote(at position: CGPoint) {
        let newNote = Note(pitch: currentPitch,
                          color: currentColor,
                          position: position,
                          size: brushSize,
                          instrument: currentInstrument,
                          effect: currentEffect,
                          visualEffect: currentVisualEffect)
        notes.append(newNote)
        playNote(note: newNote)
    }
    
    func playComposition() {
        compositionQueue.async { [weak self] in
            guard let self = self else { return }
            
            self.isPlaying = true
            var delay: TimeInterval = 0
            
            for note in self.notes {
                self.compositionQueue.asyncAfter(deadline: .now() + delay) { [weak self] in
                    guard let self = self, self.isPlaying else { return }
                    self.playNote(note: note)
                }
                delay += 0.5 / self.tempo
            }
            
            self.compositionQueue.asyncAfter(deadline: .now() + delay) { [weak self] in
                self?.isPlaying = false
            }
        }
    }
    
    func stopComposition() {
        isPlaying = false
        synthesizerQueue.async { [weak self] in
            // Stop all notes
            for pitch in 0...127 {
                self?.synthesizer?.stopNote(UInt8(pitch), onChannel: 0)
            }
        }
    }
    
    func clear() {
        notes.removeAll()
    }
}
