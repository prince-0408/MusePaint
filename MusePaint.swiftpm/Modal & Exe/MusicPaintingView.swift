//
//  MusicPaintingView.swift
//  MusePaint
//
//  Created by Prince Yadav on 06/02/25.
//
import SwiftUI

struct MusicPaintingView: View {
    @StateObject private var state = MusicPaintingState()
    @GestureState private var isDragging = false
    
    var body: some View {
        VStack {
            // Toolbar
            HStack {
                Button(action: state.playComposition) {
                    Image(systemName: state.isPlaying ? "pause.circle" : "play.circle")
                        .font(.title)
                }
                
                Button(action: state.clear) {
                    Image(systemName: "trash")
                        .font(.title)
                }
                
                Picker("Instrument", selection: $state.currentInstrument) {
                    ForEach(Instrument.allCases, id: \.self) { instrument in
                        Text(instrument.rawValue).tag(instrument)
                    }
                }
                
                Picker("Effect", selection: $state.currentEffect) {
                    ForEach(Effect.allCases, id: \.self) { effect in
                        Text(effect.rawValue).tag(effect)
                    }
                }
                
                ColorPicker("Color", selection: $state.currentColor)
                
                Slider(value: $state.brushSize, in: 10...50) {
                    Text("Size")
                }
            }
            .padding()
            
            // Canvas
            ZStack {
                Color.white
                
                ForEach(state.notes, id: \.id) { note in
                    Circle()
                        .fill(note.color)
                        .frame(width: note.size, height: note.size)
                        .position(note.position)
                        .overlay(
                            Circle()
                                .stroke(Color.black.opacity(0.2))
                        )
                }
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        state.addNote(at: value.location)
                    }
            )
        }
    }
}

// MARK: - Preview
struct MusicPaintingView_Previews: PreviewProvider {
    static var previews: some View {
        MusicPaintingView()
    }
}
