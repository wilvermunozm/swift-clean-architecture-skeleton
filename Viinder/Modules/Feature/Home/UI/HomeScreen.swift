import SwiftUI

struct HomeScreen: View {
    @Environment(\.viinderTheme) private var theme
    @Environment(\.navigationCoordinator) private var coordinator
    
    var body: some View {
        AppScaffold {
            VStack(spacing: 24) {
                Text(NSLocalizedString("home_title", comment: ""))
                    .font(theme.typography.headlineLarge)
                    .foregroundColor(theme.colors.onBackground)
                
                Text("Welcome to Viinder!")
                    .font(theme.typography.bodyLarge)
                    .foregroundColor(theme.colors.onSurface)
                
                Spacer()
                
                VStack(spacing: 16) {
                    PrimaryButton(
                        title: NSLocalizedString("profile_title", comment: ""),
                        action: { coordinator?.navigate(to: .profile) }
                    )
                    
                    Button(action: { coordinator?.navigate(to: .settings) }) {
                        Text(NSLocalizedString("settings_title", comment: ""))
                            .font(theme.typography.bodyLarge)
                            .foregroundColor(theme.colors.primary)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(theme.colors.primary, lineWidth: 1)
                            )
                    }
                }
                .padding(.bottom, 32)
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    HomeScreen()
}
