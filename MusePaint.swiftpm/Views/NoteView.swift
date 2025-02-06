//
//  NoteView.swift
//  MusePaint
//
//  Created by Prince Yadav on 03/02/25.
//
import SwiftUI

struct NoteView: View {
    let note: Note
    @State private var isAnimating = false
    @State private var rotation = 0.0
    @State private var scale = 1.0
    @State private var opacity = 1.0
    var isSelected: Bool = false // Add this line

    
    var body: some View {
        ZStack {
            Circle()
                .fill(LinearGradient(gradient: Gradient(colors: [note.color, note.color.opacity(0.7)]), startPoint: .top, endPoint: .bottom))
                .frame(width: note.size, height: note.size)
                .scaleEffect(scale)
                .opacity(opacity)
                .shadow(color: note.color.opacity(0.5), radius: 10, x: 0, y: 5) 
            
            Group {
                switch note.visualEffect {
                case .ripple:
                    ForEach(0..<3) { i in
                        Circle()
                            .stroke(note.color.opacity(0.3))
                            .frame(width: note.size * (1 + CGFloat(i) * 0.5),
                                   height: note.size * (1 + CGFloat(i) * 0.5))
                            .scaleEffect(isAnimating ? 2 : 1)
                            .opacity(isAnimating ? 0 : 1)
                            .animation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true).delay(Double(i) * 0.2), value: isAnimating)
                    }
                    
                case .starburst:
                    ForEach(0..<12) { i in
                        Rectangle()
                            .fill(note.color)
                            .frame(width: 2, height: note.size * 0.5)
                            .offset(y: -note.size * 0.5)
                            .rotationEffect(.degrees(Double(i) * 30))
                            .scaleEffect(isAnimating ? 1.5 : 1)
                            .opacity(isAnimating ? 0 : 1)
                            .animation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true).delay(Double(i) * 0.1), value: isAnimating)
                    }
                    
                case .shimmer:
                    ForEach(0..<5) { i in
                        Circle()
                            .fill(note.color.opacity(0.2))
                            .frame(width: note.size * 0.3, height: note.size * 0.3)
                            .offset(x: cos(Double(i) * .pi * 2 / 5) * note.size * 0.5,
                                    y: sin(Double(i) * .pi * 2 / 5) * note.size * 0.5)
                            .rotationEffect(.degrees(isAnimating ? 360 : 0))
                            .animation(Animation.linear(duration: 2).repeatForever(autoreverses: false), value: isAnimating)
                    }
                    
                case .pulse:
                    Circle()
                        .stroke(note.color, lineWidth: 2)
                        .frame(width: note.size, height: note.size)
                        .scaleEffect(isAnimating ? 1.5 : 1)
                        .opacity(isAnimating ? 0 : 1)
                        .animation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: isAnimating)
                    
                case .orbit:
                    ForEach(0..<3) { i in
                        Circle()
                            .fill(note.color.opacity(0.6))
                            .frame(width: note.size * 0.2, height: note.size * 0.2)
                            .offset(x: cos(Double(i) * .pi * 2 / 3 + rotation) * note.size,
                                    y: sin(Double(i) * .pi * 2 / 3 + rotation) * note.size)
                            .animation(Animation.linear(duration: 2).repeatForever(autoreverses: false), value: rotation) 
                    }
                    
                case .none:
                    EmptyView()
                }
            }
            .position(note.position)
            .onAppear {
                withAnimation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                    isAnimating = true
                    scale = note.effect == .wave ? 1.2 : 1.0
                    opacity = note.effect == .wave ? 0.7 : 1.0
                }
                
                withAnimation(Animation.linear(duration: 2.0).repeatForever(autoreverses: false)) {
                    rotation = .pi * 2
                }
            }
        }
    }
}
