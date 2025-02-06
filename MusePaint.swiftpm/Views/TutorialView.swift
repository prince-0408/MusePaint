//
//  TutorialView.swift
//  MusePaint
//
//  Created by Prince Yadav on 04/02/25.
//


import SwiftUI
import SwiftUI

struct TutorialView: View {
    @State private var currentPage = 0
    
    let tutorialSteps = [
        ("🎨 Paint with Music", "Each stroke creates a melody! Experience the magic of colors and sound.", "paintpalette.fill"),
        ("🎼 Choose Instruments", "Pick from piano, guitar, synth, or drums! Customize your symphony.", "music.note.list"),
        ("🎵 Express with Sound", "Stroke harder for louder music! Control dynamics with pressure sensitivity.", "waveform.path.ecg"),
        ("↩️ Undo & Restart", "Refine your masterpiece! Undo mistakes and start fresh anytime.", "arrow.uturn.left.circle.fill")
    ]
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.purple, Color.blue]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
                .opacity(0.8)
            
            VStack {
                Text("🎶 Welcome to MusePaint 🎶")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                    .shadow(radius: 10)
                    .padding(.top, 40)
                    .scaleEffect(currentPage == 0 ? 1.1 : 1)
                    .animation(.easeInOut(duration: 0.5), value: currentPage)
                
                GeometryReader { geo in
                    TabView(selection: $currentPage) {
                        ForEach(0..<tutorialSteps.count, id: \ .self) { index in
                            StoryCardView(
                                title: tutorialSteps[index].0,
                                description: tutorialSteps[index].1,
                                image: tutorialSteps[index].2,
                                size: geo.size
                            )
                            .tag(index)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                }
                .frame(height: UIScreen.main.bounds.height * 0.6)
                
                Spacer()
                
                HStack {
                    if currentPage > 0 {
                        Button(action: {
                            withAnimation(.spring()) { currentPage -= 1 }
                        }) {
                            Text("⬅️ Back")
                                .font(.title.bold())
                                .padding()
                                .frame(width: 240, height: 60)
                                .background(Color.white.opacity(0.2))
                                .clipShape(RoundedRectangle(cornerRadius: 25))
                                .foregroundColor(.white)
                        }
                    }
                    Spacer()
                    Button(action: {
                        withAnimation(.spring()) {
                            if currentPage < tutorialSteps.count - 1 {
                                currentPage += 1
                            }
                        }
                    }) {
                        Text(currentPage == tutorialSteps.count - 1 ? "🎨 Start Painting!" : "Next ➡️")
                            .font(.title.bold())
                            .padding()
                            .frame(width: 240, height: 60)
                            .background(Color.white.opacity(0.2))
                            .clipShape(RoundedRectangle(cornerRadius: 25))
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal, 50)
                .padding(.bottom, 40)
            }
        }
    }
}

struct StoryCardView: View {
    let title: String
    let description: String
    let image: String
    let size: CGSize
    @State private var floating = false
    
    var body: some View {
        VStack(spacing: 30) {
            Text(title)
                .font(.system(size: 40, weight: .bold))
                .foregroundColor(.white)
                .shadow(radius: 5)
                .offset(y: floating ? -5 : 5)
                .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: floating)
            
            Image(systemName: image)
                .resizable()
                .scaledToFit()
                .frame(height: 200)
                .foregroundColor(.white)
                .shadow(radius: 10)
                .rotation3DEffect(.degrees(floating ? 15 : -15), axis: (x: 0, y: 1, z: 0))
                .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: floating)
            
            Text(description)
                .font(.title2)
                .foregroundColor(.white.opacity(0.9))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 50)
                .opacity(floating ? 1 : 0.9)
                .animation(.easeInOut(duration: 1), value: floating)
        }
        .frame(width: size.width * 0.8, height: size.height * 0.65)
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(Color.white.opacity(0.15))
                .shadow(radius: 15)
                .overlay(
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(Color.white.opacity(0.3), lineWidth: 2)
                )
        )
        .padding()
        .onAppear { floating = true }
    }
}





struct TutorialView_Previews: PreviewProvider {
    static var previews: some View {
        TutorialView()
    }
}
