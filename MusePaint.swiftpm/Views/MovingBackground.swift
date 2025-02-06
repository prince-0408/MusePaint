//
//  MovingCirclesBackground.swift
//  MusePaint
//
//  Created by Prince Yadav on 05/02/25.
//
import SwiftUI

struct AnimatedBackground: View {
    @State private var animateGradient = false
    
    var body: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                animateGradient ? Color.blue : Color.purple,
                animateGradient ? Color.pink : Color.orange
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
                    .edgesIgnoringSafeArea(.all)
        .onAppear {
            withAnimation(Animation.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                animateGradient.toggle()
            }
        }
    }
}

struct MovingCirclesBackground: View {
    @State private var move = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(0..<10) { _ in
                    Circle()
                        .fill(Color.white.opacity(0.2))
                        .frame(width: CGFloat.random(in: 40...120), height: CGFloat.random(in: 40...120))
                        .position(
                            x: CGFloat.random(in: 0...geometry.size.width),
                            y: CGFloat.random(in: 0...geometry.size.height)
                        )
                        .offset(y: move ? 100 : -100)
                        .animation(
                            Animation.easeInOut(duration: Double.random(in: 3...6))
                                .repeatForever(autoreverses: true)
                        )
                }
            }
            .onAppear {
                move.toggle()
            }
        }
        .ignoresSafeArea()
    }
}

struct MovingEmojisBackground: View {
    @State private var move = false
    let emojis = ["🎵", "🎨", "🎶", "🖌️", "🎼", "🖍️"]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(0..<10) { _ in
                    Text(emojis.randomElement() ?? "🎵")
                        .font(.system(size: CGFloat.random(in: 40...80)))
                        .position(
                            x: CGFloat.random(in: 0...geometry.size.width),
                            y: CGFloat.random(in: 0...geometry.size.height)
                        )
                        .offset(y: move ? 100 : -100)
                        .animation(
                            Animation.easeInOut(duration: Double.random(in: 4...7))
                                .repeatForever(autoreverses: true)
                        )
                }
            }
            .onAppear {
                move.toggle()
            }
        }
        .ignoresSafeArea()
    }
}

struct ParallaxBackground: View {
    @State private var offsetY: CGFloat = 0.0
    
    var body: some View {
        GeometryReader { geometry in
            Image("music_paint_background") // Replace with your background image 🎵🎨
                .resizable()
                .scaledToFill()
                .frame(width: geometry.size.width, height: geometry.size.height)
                .offset(y: offsetY * -0.3)
                .onAppear {
                    withAnimation(Animation.easeInOut(duration: 5).repeatForever(autoreverses: true)) {
                        offsetY = 50
                    }
                }
        }
        .ignoresSafeArea()
    }
}
