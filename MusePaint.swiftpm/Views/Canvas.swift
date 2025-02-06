//
//  Canvas.swift
//  MusePaint
//
//  Created by Prince Yadav on 03/02/25.
//

import SwiftUICore
import SwiftUI


struct Canvas: View {
    @ObservedObject var state: MusicPaintingState
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.black.opacity(0.1)
                
                ForEach(state.notes.indices, id: \.self) { index in
                    Circle()
                        .fill(state.notes[index].color)
                        .frame(width: state.notes[index].size,
                               height: state.notes[index].size)
                        .position(state.notes[index].position)
                        .animation(.spring())
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
