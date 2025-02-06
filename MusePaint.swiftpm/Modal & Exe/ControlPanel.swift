//
//  ControlPanel.swift
//  MusePaint
//
//  Created by Prince Yadav on 03/02/25.
//
import SwiftUI

struct ControlPanel: View {
    @Binding var selectedColor: Color
    @Binding var selectedInstrument: Instrument
    @Binding var selectedEffect: Effect
    @Binding var brushSize: Double
    @Binding var tempo: Double
    @Binding var selectedVisualEffect: VisualEffect
    @Binding var reverbAmount: Double
    
    let colors: [Color] = [
        Color(red: 0.1, green: 0.6, blue: 0.8),
        Color(red: 0.9, green: 0.2, blue: 0.3),
        Color(red: 0.2, green: 0.8, blue: 0.2),
        Color(red: 1.0, green: 0.8, blue: 0.0),
        Color(red: 0.5, green: 0.0, blue: 0.5),
        Color(red: 1.0, green: 0.5, blue: 0.0),
        Color(red: 1.0, green: 0.4, blue: 0.6),
        Color(red: 0.0, green: 0.5, blue: 1.0)
    ]
    
    @Environment(\.colorScheme) var colorScheme
    
    private var foregroundColor: Color {
        colorScheme == .dark ? .white : .black
    }
    
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 12) {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(colors, id: \.self) { color in
                            ColorButton(color: color, isSelected: selectedColor == color) {
                                withAnimation(.spring(response: 0.3)) {
                                    selectedColor = color
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 8)
                }
                .frame(height: 45)
                
                Rectangle()
                    .fill(foregroundColor.opacity(0.1))
                    .frame(width: 1, height: 30)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(Instrument.allCases, id: \.self) { instrument in
                            InstrumentButton(
                                instrument: instrument,
                                isSelected: selectedInstrument == instrument,
                                foregroundColor: foregroundColor
                            ) {
                                withAnimation(.spring(response: 0.3)) {
                                    selectedInstrument = instrument
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 8)
                }
            }
            .padding(12)
            .background(.ultraThinMaterial)
            .cornerRadius(16)
            
            VStack(spacing: 12) {
                CompactSlider(
                    value: $brushSize,
                    label: "Brush",
                    icon: "paintbrush.fill",
                    range: 10...50,
                    tint: .blue,
                    foregroundColor: foregroundColor
                )
                
                CompactSlider(
                    value: $tempo,
                    label: "Tempo",
                    icon: "metronome.fill",
                    range: 0.5...2.0,
                    tint: .green,
                    foregroundColor: foregroundColor
                )
                
                CompactSlider(
                    value: $reverbAmount,
                    label: "Reverb",
                    icon: "waveform",
                    range: 0...100,
                    tint: .purple,
                    foregroundColor: foregroundColor
                )
            }
            .padding(12)
            .background(.ultraThinMaterial)
            .cornerRadius(16)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(VisualEffect.allCases, id: \.self) { effect in
                        EffectButton(
                            effect: effect,
                            isSelected: selectedVisualEffect == effect,
                            foregroundColor: foregroundColor
                        ) {
                            withAnimation(.spring(response: 0.3)) {
                                selectedVisualEffect = effect
                            }
                        }
                    }
                }
                .padding(.horizontal, 12)
            }
            .frame(height: 45)
        }
        .padding(16)
        .background(.ultraThinMaterial)
        .cornerRadius(24)
    }
}

struct InstrumentButton: View {
    let instrument: Instrument
    let isSelected: Bool
    let foregroundColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                instrumentIcon(for: instrument)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 24)
                    .foregroundColor(isSelected ? foregroundColor : foregroundColor.opacity(0.6))
                
                Text(instrument.rawValue)
                    .font(.caption2)
                    .foregroundColor(isSelected ? foregroundColor : foregroundColor.opacity(0.6))
            }
            .padding(8)
            .background(isSelected ? Material.ultraThinMaterial : Material.thinMaterial)

            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct EffectButton: View {
    let effect: VisualEffect
    let isSelected: Bool
    let foregroundColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(effect.rawValue)
                .font(.caption)
                .foregroundColor(isSelected ? .white : foregroundColor)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    isSelected ?
                        AnyShapeStyle(foregroundColor.opacity(0.6)) :
                        AnyShapeStyle(.ultraThinMaterial)
                )
                .clipShape(Capsule())
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct CompactSlider: View {
    @Binding var value: Double
    let label: String
    let icon: String
    let range: ClosedRange<Double>
    let tint: Color
    let foregroundColor: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(foregroundColor.opacity(0.7))
                .frame(width: 20)
            
            Slider(value: $value, in: range)
                .accentColor(tint)
            
            Text(String(format: "%.1f", value))
                .foregroundColor(foregroundColor.opacity(0.7))
                .font(.caption)
                .frame(width: 35)
        }
    }
}


    func instrumentIcon(for instrument: Instrument) -> Image {
        switch instrument {
        case .none: return Image("None")
        case .piano: return Image("piano") // Assuming you named the asset "piano"
        case .guitar: return Image("guitar") // Assuming you named the asset "guitar"
        case .flute: return Image("flute") // Assuming you named the asset "flute"
        case .violin: return Image("violin") // Assuming you named the asset "violin"
        case .trumpet: return Image("trumpet") // Assuming you named the asset "trumpet"
        case .marimba: return Image("marimba") // Assuming you named the asset "marimba"
        case .musicBox: return Image("musicBox") // Assuming you named the asset "musicBox"
        }
    }

