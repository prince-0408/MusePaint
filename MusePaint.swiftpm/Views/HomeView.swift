//
//  HomeView.swift
//  MusePaint
//
//  Created by Prince Yadav on 04/02/25.
//


import SwiftUI

struct HomeView: View {
    @State private var buttonScale: CGFloat = 1.0
    @State private var showingSettingView = false
    let navigate: (AppStep) -> Void

    
    var body: some View {
        NavigationStack {
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
                
                VStack(spacing: 35) {
                    VStack(spacing: 15) {
                        Text("MusePaint")
                            .font(.system(size: 48, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
                    }
                    .padding(.top, 60)
                    
                    Text("Where Art Meets Music")
                        .font(.title2)
                        .foregroundColor(.white.opacity(0.9))
                        .fontWeight(.medium)
                        .padding(.top, 10)
                    
                    Spacer()
                    
                    VStack(spacing: 25) {
                        NavigationLink(destination: ContentView(state: MusicPaintingState())) {
                            MenuButtonContent(
                                title: "Start Creating",
                                icon: "paintbrush.fill"
                            )
                        }
                        
                        NavigationLink(destination: TutorialView()) {
                            MenuButtonContent(
                                title: "Tutorials",
                                icon: "book.fill"
                            )
                        }
                        
                        NavigationLink(destination: SettingsView(isPresented: $showingSettingView)) {
                            MenuButtonContent(
                                title: "Settings",
                                icon: "gearshape.fill"
                            )
                        }
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 50)
                .edgesIgnoringSafeArea(.all)
            }
        }
    }
}

struct MenuButtonContent: View {
    let title: String
    let icon: String
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.title2)
            Text(title)
                .font(.title3)
                .fontWeight(.semibold)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 60)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.white.opacity(0.15))
                
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
            }
        )
        .foregroundColor(.white)
        .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 5)
    }
}

