//
//  OnboardingView.swift
//  MusePaint
//
//  Created by Prince Yadav on 04/02/25.
//


import SwiftUI


struct OnboardingView: View {
    @State private var currentPage = 0
    @State private var isActive = false
    let onComplete: () -> Void

    var body: some View {
        ZStack {
            
        AnimatedBackground()
            .edgesIgnoringSafeArea(.all)

        ParallaxBackground()
            .edgesIgnoringSafeArea(.all)

        MovingCirclesBackground()
            .edgesIgnoringSafeArea(.all)

        MovingEmojisBackground()
            .edgesIgnoringSafeArea(.all)

            
            TabView(selection: $currentPage) {
                ForEach(0..<onboardingData.count, id: \.self) { index in
                    OnboardingPage(data: onboardingData[index])
                            .tag(index)
                            .rotation3DEffect(
                            .degrees(Double(currentPage - index) * 10),
                            axis: (x: 0, y: 1, z: 0)
                            )
                        .scaleEffect(currentPage == index ? 1.0 : 0.9)
                        .animation(.easeInOut, value: currentPage)
                }
            }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                .animation(.easeInOut, value: currentPage)

            // Navigation buttons
            VStack {
                Spacer()

                HStack {
                    GlassmorphicButton(
                        action: { isActive = true },
                        title: "Skip",
                        textColor: .white.opacity(0.8)
                    )
                    .padding(.leading, 20)

                    Spacer()

                    if currentPage < onboardingData.count - 1 {
                        GlassmorphicButton(
                            action: { currentPage += 1 },
                            title: "Next",
                            textColor: .white.opacity(0.9)
                        )
                        .padding(.trailing, 20)
                    } else {
                        GlassmorphicButton(
                            action: { isActive = true },
                            title: "Get Started",
                            textColor: .white
                        )
                        .padding(.trailing, 20)
                    }
                }
                .padding(.bottom, 40)
            }
        }
        .onChange(of: isActive) { active in
            if active {
                onComplete()
            }
        }
    }
}

// Glassmorphic Button (Improved)
struct GlassmorphicButton: View {
    var action: () -> Void
    var title: String
    var textColor: Color

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.title.bold())
                .frame(width: 200, height: 60)
                .background(
                    LinearGradient(gradient: Gradient(colors: [Color.white.opacity(0.3), Color.white.opacity(0.1)]),
                                   startPoint: .topLeading,
                                   endPoint: .bottomTrailing)
                        .blur(radius: 10)
                )
                .clipShape(RoundedRectangle(cornerRadius: 25))
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color.white.opacity(0.5), lineWidth: 1)
                )
                .foregroundColor(textColor)
        }
        .opacity(0.9)
        .shadow(radius: 10)
    }
}

    private func textColor(for page: Int) -> Color {
        switch page {
        case 0:
            return .white
        case 1:
            return .black
        case 2:
            return .white
        case 3:
            return .black
        default:
            return .white
        }
    }



struct OnboardingData {
    let imageName: String
    let title: String
    let description: String
}

let onboardingData = [
    OnboardingData(
        imageName: "drawing",
        title: "Create Music by Drawing",
        description: "Turn your sketches into melodies! Every stroke you draw translates into unique musical notes, letting you compose in a fun and intuitive way."
    ),
    
    OnboardingData(
        imageName: "brush",
        title: "Customizable Brushes",
        description: "Express your creativity with a variety of brush styles! Different brushes influence the tone, intensity, and rhythm of your musical composition."
    ),
    
    OnboardingData(
        imageName: "play",
        title: "Play & Refine Your Composition",
        description: "Instantly listen to your artwork come to life. Adjust, tweak, and fine-tune your composition until it sounds just right!"
    ),
    
    OnboardingData(
        imageName: "export",
        title: "Save, Share & Inspire",
        description: "Export your musical masterpiece as an audio file or sheet music. Share your unique creations with friends, or showcase them to the world!"
    )
]


struct VisualEffectBlur: UIViewRepresentable {
    var blurStyle: UIBlurEffect.Style

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        let blurEffect = UIBlurEffect(style: blurStyle)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(blurEffectView)

        NSLayoutConstraint.activate([
            blurEffectView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurEffectView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blurEffectView.topAnchor.constraint(equalTo: view.topAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}


struct ShakeEffect: ViewModifier {
    @State private var offset: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .offset(x: offset)
            .onAppear {
                withAnimation(Animation.linear(duration: 0.1).repeatCount(3, autoreverses: true)) {
                    offset = 10
                }
            }
    }
}

struct OnboardingPage: View {
    let data: OnboardingData
    
    var body: some View {
        ZStack {
           
            VStack(spacing: 20) {
                Image(data.imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 280)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(radius: 10)
                    .padding()
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 0.5))

                Text(data.title)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .transition(.move(edge: .top))
                    .animation(.easeInOut(duration: 0.6))

                Text(data.description)
                    .font(.system(size: 18))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white.opacity(0.9))
                    .padding(.horizontal, 30)
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 0.7))

            }
            .padding(.bottom, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.clear) 
    }
}


struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(onComplete: {})
    }
}
