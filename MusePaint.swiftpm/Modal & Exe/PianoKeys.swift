//
//  PianoKeys.swift
//  MusePaint
//
//  Created by Prince Yadav on 03/02/25.
//

import SwiftUICore
import SwiftUI




struct NoteLabel: View {
    let note: String
    let color: Color
    
    var body: some View {
        Text(note)
            .font(.system(size: 14, weight: .medium))
            .foregroundColor(color)
            .frame(height: 20)
    }
}

struct WhiteKeyView: View {
    let pitch: Int
    let width: CGFloat
    let selectedPitch: Int
    let colorScheme: PianoColorScheme
    let showLabels: Bool
    let action: () -> Void
    
    private let noteNames = ["C", "D", "E", "F", "G", "A", "B"]
    
    private var noteName: String {
        let noteIndex = (pitch - 48) % 12
        let octave = (pitch - 48) / 12 + 4
        if [0, 2, 4, 5, 7, 9, 11].contains(noteIndex) {
            return "\(noteNames[noteIndex / 2])\(octave)"
        }
        return ""
    }
    
    var body: some View {
        VStack(spacing: 0) {
            if showLabels {
                NoteLabel(note: noteName, color: colorScheme.labelColor)
            }
            Rectangle()
                .fill(selectedPitch == pitch ? colorScheme.selectedColor.opacity(0.5) : colorScheme.whiteKeyColor)
                .frame(width: width, height: 180)
                .cornerRadius(8)
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                .overlay(
                    Rectangle()
                        .stroke(colorScheme.blackKeyColor, lineWidth: 1)
                )
                .scaleEffect(selectedPitch == pitch ? 1.05 : 1.0)
                .animation(.easeInOut(duration: 0.1), value: selectedPitch)
                .onTapGesture(perform: action)
        }
    }
}

struct BlackKeyView: View {
    let pitch: Int
    let width: CGFloat
    let xOffset: CGFloat
    let selectedPitch: Int
    let colorScheme: PianoColorScheme
    let action: () -> Void
    
    var body: some View {
        Rectangle()
            .fill(selectedPitch == pitch ? colorScheme.selectedColor.opacity(0.7) : colorScheme.blackKeyColor)
            .frame(width: width, height: 120)
            .cornerRadius(8)
            .shadow(color: Color.black.opacity(0.5), radius: 5, x: 0, y: 5)
            .offset(x: xOffset)
            .scaleEffect(selectedPitch == pitch ? 1.1 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: selectedPitch)
            .onTapGesture(perform: action)
    }
}

struct OctaveView: View {
    let baseNote: Int
    let whiteKeyWidth: CGFloat
    let blackKeyWidth: CGFloat
    let selectedPitch: Int
    let colorScheme: PianoColorScheme
    let showLabels: Bool
    let onKeyPressed: (Int) -> Void
    
    private let whiteKeys = [0, 2, 4, 5, 7, 9, 11]
    private let blackKeys = [1, 3, -1, 6, 8, 10]
    
    var body: some View {
        ZStack {
            // White keys
            HStack(spacing: 3) {
                ForEach(0..<7, id: \.self) { index in
                    let pitch = baseNote + whiteKeys[index]
                    WhiteKeyView(
                        pitch: pitch,
                        width: whiteKeyWidth,
                        selectedPitch: selectedPitch,
                        colorScheme: colorScheme,
                        showLabels: showLabels,
                        action: { onKeyPressed(pitch) }
                    )
                }
            }
            
            // Black keys
            HStack(spacing: 3) {
                ForEach(0..<6, id: \.self) { index in
                    if blackKeys[index] != -1 {
                        let pitch = baseNote + blackKeys[index]
                        BlackKeyView(
                            pitch: pitch,
                            width: blackKeyWidth,
                            xOffset: CGFloat(index) * whiteKeyWidth +
                                    CGFloat(index > 2 ? whiteKeyWidth : 0) +
                                    (whiteKeyWidth - blackKeyWidth) / 2,
                            selectedPitch: selectedPitch,
                            colorScheme: colorScheme,
                            action: { onKeyPressed(pitch) }
                        )
                    }
                }
            }
        }
    }
}

struct PianoKeys: View {
    @Binding var selectedPitch: Int
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    let baseNote = 48
    
    var colorScheme: PianoColorScheme = .classic
    var showLabels: Bool = true
    
    private var isLandscape: Bool {
        horizontalSizeClass == .regular && verticalSizeClass == .regular
    }
    
    private var octaveCount: Int {
        let screenWidth = UIScreen.main.bounds.width
        let keyWidth: CGFloat = isLandscape ? 70 : 60
        let totalWidth = CGFloat(7) * keyWidth
        let maxOctaves = Int(screenWidth / totalWidth)
        return max(1, min(maxOctaves, 6))
    }
    
    private var whiteKeyWidth: CGFloat {
        isLandscape ? 70 : 60
    }
    
    private var blackKeyWidth: CGFloat {
        whiteKeyWidth * 0.65
    }
    
    private var pianoHeight: CGFloat {
        showLabels ? 220 : 200
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    ForEach(0..<octaveCount, id: \.self) { octave in
                        OctaveView(
                            baseNote: baseNote + (octave * 12),
                            whiteKeyWidth: whiteKeyWidth,
                            blackKeyWidth: blackKeyWidth,
                            selectedPitch: selectedPitch,
                            colorScheme: colorScheme,
                            showLabels: showLabels,
                            onKeyPressed: { pitch in
                                selectedPitch = pitch
                            }
                        )
                    }
                }
                .padding()
                .frame(minWidth: geometry.size.width)
                .background(colorScheme.backgroundColor)
                .cornerRadius(15)
                .padding(.horizontal)
            }
        }
        .frame(height: pianoHeight)
    }
}

// Preview provider
struct PianoKeys_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PianoKeys(selectedPitch: .constant(60))
                .previewDevice("iPad Pro (12.9-inch)")
                .previewDisplayName("iPad Pro - Classic")
                .previewInterfaceOrientation(.landscapeLeft)
            
            PianoKeys(selectedPitch: .constant(60), colorScheme: .warm)
                .previewDevice("iPad mini (6th generation)")
                .previewDisplayName("iPad mini - Warm")
            
            PianoKeys(selectedPitch: .constant(60), colorScheme: .cool)
                .previewDevice("iPad Air (5th generation)")
                .previewDisplayName("iPad Air - Cool")
        }
    }
}



