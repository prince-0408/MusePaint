import SwiftUI

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            AppCoordinator()
        }
    }
}

struct AppCoordinator: View {
    @State private var currentStep: AppStep = UserDefaults.standard.bool(forKey: "hasSeenOnboarding") ? .launchScreen : .onboarding
    @State private var isSettingsPresented = false  

    var body: some View {
        ZStack {
            switch currentStep {
            case .launchScreen:
                LaunchScreenView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation { currentStep = .home }
                        }
                    }

            case .onboarding:
                OnboardingView {
                    UserDefaults.standard.set(true, forKey: "hasSeenOnboarding") 
                    withAnimation { currentStep = .home }
                }

            case .home:
                HomeView(navigate: { step in
                    if step == .settings {
                        isSettingsPresented = true
                    } else {
                        withAnimation { currentStep = step }
                    }
                })

            case .content:
                ContentView(state: MusicPaintingState())

            case .settings:
                EmptyView()
            }
        }
        .transition(.opacity)
        .animation(.easeInOut, value: currentStep)
        .sheet(isPresented: $isSettingsPresented) {
            SettingsView(isPresented: $isSettingsPresented)
        }
    }
}

enum AppStep {
    case launchScreen, onboarding, home, content, settings
}
