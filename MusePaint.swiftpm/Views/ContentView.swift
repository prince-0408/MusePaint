



import SwiftUI

struct ContentView: View {
    @ObservedObject var state: MusicPaintingState
    @State private var showingHelp = false
    @State private var isSettingsPresented = false
    @State private var selectedScheme: PianoColorScheme = .classic
    
    var body: some View {
        ZStack {
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
                HStack {
                    Text("MusePaint - Music Painting Studio")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(selectedScheme.labelColor)
                        .padding(.leading)
                        .shadow(radius: 3)

                    Spacer()

                    Button(action: { showingHelp = true }) {
                        Image(systemName: "questionmark.circle.fill")
                            .font(.title)
                            .foregroundColor(selectedScheme.labelColor)
                            .padding()
                            .background(Circle().fill(Color.white.opacity(0.2)))
                    }

                    Button(action: {
                        withAnimation {
                            isSettingsPresented.toggle()
                        }
                    }) {
                        Image(systemName: "gearshape.fill")
                            .font(.title)
                            .foregroundColor(selectedScheme.labelColor)
                            .padding()
                            .background(Circle().fill(Color.white.opacity(0.2)))
                    }
                }
                .padding(.top)
                
                ColorSchemePicker(selectedScheme: $selectedScheme, schemes: [
                    .classic,
                    .warm,
                    .cool,
                    .vibrant,
                    .darkMode,
                    .pastel,
                    .neon
                ])
                .padding(.horizontal)
                
                ControlPanel(
                    selectedColor: $state.currentColor,
                    selectedInstrument: $state.currentInstrument,
                    selectedEffect: $state.currentEffect,
                    brushSize: Binding(
                        get: { Double(state.brushSize) },
                        set: { state.brushSize = CGFloat($0) }
                    ),
                    tempo: $state.tempo,
                    selectedVisualEffect: $state.currentVisualEffect,
                    reverbAmount: $state.reverbAmount
                )
                .padding(.horizontal)
                
                Canvas(state: state)
                    .frame(maxHeight: .infinity)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .padding()
                
                VStack(spacing: 20) {
                    PianoKeys(selectedPitch: $state.currentPitch, colorScheme: selectedScheme)

                    HStack {
                        Button(action: {
                            if state.isPlaying {
                                state.stopComposition()
                            } else {
                                state.playComposition()
                            }
                        }) {
                            MenuButtonContent(
                                title: state.isPlaying ? "Stop" : "Play",
                                icon: state.isPlaying ? "stop.fill" : "play.fill"
                            )
                        }

                        Button(action: {
                            state.clear()
                        }) {
                            MenuButtonContent(
                                title: "Clear",
                                icon: "trash.fill"
                            )
                        }
                    }
                }
                .padding(.bottom)
            }
            .padding()
            
            if isSettingsPresented {
                HStack {
                    Spacer()
                    
                    SettingsView(isPresented: $isSettingsPresented)
                        .frame(width: 260, height: UIScreen.main.bounds.height * 0.8)
                        .background(
                            Color.black.opacity(0.85)
                        )
                        .mask(
                            RoundedCorner(radius: 15, corners: [.topLeft, .bottomLeft])
                        )
                        .overlay(
                            RoundedCorner(radius: 15, corners: [.topLeft, .bottomLeft])
                                .stroke(Color.white.opacity(0.2), lineWidth: 1)
                        )
                        .shadow(color: .black.opacity(0.3), radius: 10, x: -5, y: 0)
                        .offset(x: isSettingsPresented ? 0 : 300)
                        .animation(.spring(response: 0.4, dampingFraction: 0.75, blendDuration: 0.3), value: isSettingsPresented)
                        .padding(.top, 50)
                        .padding(.bottom, 50)
                }
                .edgesIgnoringSafeArea(.vertical)
            }

        }
        .alert(isPresented: $showingHelp) {
            Alert(
                title: Text("How to Use"),
                message: Text("• Tap or drag on the canvas to create musical notes\n• Choose colors, instruments, and effects from the control panel\n• Adjust brush size, tempo, and reverb\n• Add visual effects to your notes\n• Play your composition with the play button\n• Clear the canvas to start over"),
                dismissButton: .default(Text("Got it!"))
            )
        }
    }
}

struct ColorSchemePicker: View {
    @Binding var selectedScheme: PianoColorScheme
    let schemes: [PianoColorScheme]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("🎨 Choose Your Theme")
                .font(.title3.bold())
                .foregroundColor(.primary)
                .padding(.leading, 12)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(schemes, id: \.self) { scheme in
                        ColorSchemeCard(scheme: scheme, isSelected: selectedScheme == scheme) {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                selectedScheme = scheme
                                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                            }
                        }
                    }
                }
                .padding(.horizontal, 12)
            }
        }
        .padding(.vertical, 10)
    }
}

struct ColorSchemeCard: View {
    let scheme: PianoColorScheme
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [scheme.whiteKeyColor, scheme.blackKeyColor]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(width: 60, height: 60)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(isSelected ? scheme.selectedColor : Color.clear, lineWidth: 3)
                            .shadow(color: isSelected ? scheme.selectedColor.opacity(0.5) : Color.clear, radius: 5)
                    )

                Text(scheme.id.capitalized)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
            }
            .frame(width: 70)
            .padding(6)
            .background(isSelected ? scheme.backgroundColor.opacity(0.2) : Color.clear)
            .cornerRadius(10)
            .scaleEffect(isSelected ? 1.1 : 1.0)
            .animation(.easeInOut(duration: 0.2), value: isSelected)
        }
    }
}


struct ColorSchemeButton: View {
    let scheme: PianoColorScheme
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(scheme.selectedColor)
                    .frame(width: isSelected ? 55 : 45, height: isSelected ? 55 : 45)
                    .shadow(color: scheme.selectedColor.opacity(0.4), radius: 5, x: 0, y: 3)
                    .overlay(
                        Circle()
                            .stroke(isSelected ? Color.white.opacity(0.6) : Color.clear, lineWidth: 3)
                    )

                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                }
            }
        }
        .padding(6)
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat
    var corners: UIRectCorner

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
