//
//  SettingsView.swift
//  MusePaint
//
//  Created by Prince Yadav on 04/02/25.
//

import SwiftUI

struct SettingsView: View {
    @Binding var isPresented: Bool
    @State private var soundEffectsEnabled: Bool = true
    @AppStorage("musicEnabled") private var musicEnabled: Bool = true
    @State private var brushSize: Double = 5.0
    @State private var brushOpacity: Double = 1.0
    @State private var selectedColor: Color = .black
    
    private let colorPresets: [Color] = [
        .black, .red, .blue, .green, .yellow, .purple, .orange
    ]
    
    var body: some View {
        ZStack {
            // 🌈 Gradient Background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.98, green: 0.80, blue: 0.85), // Soft pink
                    Color(red: 0.85, green: 0.75, blue: 0.95), // Lavender
                    Color(red: 0.70, green: 0.85, blue: 0.98)  // Light blue
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack {
                Form {
                    Section(header: Text("🎵 Audio Settings")) {
                        Toggle("Sound Effects", isOn: $soundEffectsEnabled)
                            .toggleStyle(SwitchToggleStyle(tint: .blue))
                        
                        Toggle("Background Music", isOn: $musicEnabled)
                            .toggleStyle(SwitchToggleStyle(tint: .blue))
                    }
                    .listRowBackground(transparentGradient)
                    
                    Section(header: Text("🎨 Brush Settings")) {
                        HStack {
                            Text("Size: \(Int(brushSize))")
                                .frame(width: 80, alignment: .leading)
                            Slider(value: $brushSize, in: 1...20, step: 1)
                                .accentColor(.blue)
                        }
                        
                        HStack {
                            Text("Opacity: \(brushOpacity, specifier: "%.2f")")
                                .frame(width: 80, alignment: .leading)
                            Slider(value: $brushOpacity, in: 0...1, step: 0.05)
                                .accentColor(.blue)
                        }
                    }
                    .listRowBackground(transparentGradient)
                    
                    Section(header: Text("🎨 Color Presets")) {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 44))], spacing: 10) {
                            ForEach(colorPresets, id: \.self) { color in
                                ColorButton(color: color, isSelected: color == selectedColor) {
                                    selectedColor = color
                                }
                            }
                        }
                        .padding(.vertical, 8)
                    }
                    .listRowBackground(transparentGradient)
                    
                    Section(header: Text("ℹ️ App Information")) {
                        HStack {
                            Text("Version")
                            Spacer()
                            Text("1.0.0")
                                .foregroundColor(.gray)
                        }
                        
                        HStack {
                            Text("Build")
                            Spacer()
                            Text("2025.1")
                                .foregroundColor(.gray)
                        }
                    }
                    .listRowBackground(transparentGradient)
                }
                .scrollContentBackground(.hidden)
                
                // 🌟 "Done" Button with Glassmorphic Effect
                Button(action: { isPresented = false }) {
                    Text("Done")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(Color.white.opacity(0.2))
                                .blur(radius: 10)
                        )
                        .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 20)
                }
            }
            .padding()
        }
    }
    
    private var transparentGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [Color.white.opacity(0.2), Color.white.opacity(0.05)]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

struct ColorButton: View {
    let color: Color
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Circle()
                .fill(color)
                .frame(width: 44, height: 44)
                .overlay(
                    Circle()
                        .strokeBorder(isSelected ? .blue : .gray.opacity(0.3), lineWidth: 3)
                )
                .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(isPresented: .constant(true))
            .preferredColorScheme(.dark)
    }
}
