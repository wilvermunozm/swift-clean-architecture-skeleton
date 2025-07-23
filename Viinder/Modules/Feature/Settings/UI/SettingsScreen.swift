import SwiftUI

struct SettingsScreen: View {
    @Environment(\.viinderTheme) private var theme
    
    var onBack: () -> Void = {}
    var onLogout: () -> Void = {}
    
    var body: some View {
        AppScaffold {
            VStack(spacing: 24) {
                Text(NSLocalizedString("settings_title", comment: ""))
                    .font(theme.typography.headlineLarge)
                    .foregroundColor(theme.colors.onBackground)
                
                Text("Settings Screen - Coming Soon")
                    .font(theme.typography.bodyLarge)
                    .foregroundColor(theme.colors.onSurface)
                
                Spacer()
                
                PrimaryButton(
                    title: NSLocalizedString("logout_action", comment: ""),
                    action: onLogout
                )
                .padding(.bottom, 32)
            }
            .padding(.horizontal)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: onBack) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(theme.colors.onBackground)
                }
            }
        }
    }
}

#Preview {
    SettingsScreen()
}
