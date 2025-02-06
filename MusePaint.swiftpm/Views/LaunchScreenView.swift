//
//  LaunchScreenView.swift
//  MusePaint
//
//  Created by Prince Yadav on 03/02/25.
//


import SwiftUI

struct LaunchScreenView: View {
    @State private var isAnimating = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.98, green: 0.80, blue: 0.85),
                    Color(red: 0.85, green: 0.75, blue: 0.95),
                    Color(red: 0.70, green: 0.85, blue: 0.98)  
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
            
            RadialGradient(
                gradient: Gradient(colors: [
                    Color.white.opacity(0.2),
                    Color.clear
                ]),
                center: .center,
                startRadius: 0,
                endRadius: 300
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Image("MusePaint")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .cornerRadius(18)
                    .foregroundColor(.purple)
                    .animation(
                            Animation.easeInOut(duration: 1.0)
                                .repeatForever(autoreverses: true),
                            value: isAnimating
                        )
                    .scaleEffect(isAnimating ? 1.2 : 1.0)
                    .padding()
                    .cornerRadius(15)
                    .shadow(radius: 5)
                
                
                Text("Musepaint")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .opacity(isAnimating ? 1.0 : 0.0)
                    .animation(
                        Animation.easeIn(duration: 0.8)
                            .delay(0.3),
                        value: isAnimating
                    )
                
                Text("Where Art Meets Inspiration")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .opacity(isAnimating ? 1.0 : 0.0)
                    .animation(
                        Animation.easeIn(duration: 0.8)
                            .delay(0.5),
                        value: isAnimating
                    )
            }
        }
        .onAppear {
            isAnimating = true
        }
    }
}

struct LaunchScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreenView()
    }
}
