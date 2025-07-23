import SwiftUI

struct ProfileScreen: View {
    @Environment(\.viinderTheme) private var theme
    
    var onBack: () -> Void = {}
    
    var body: some View {
        AppScaffold {
            VStack(spacing: 24) {
                Text(NSLocalizedString("profile_title", comment: ""))
                    .font(theme.typography.headlineLarge)
                    .foregroundColor(theme.colors.onBackground)
                
                Text("Profile Screen - Coming Soon")
                    .font(theme.typography.bodyLarge)
                    .foregroundColor(theme.colors.onSurface)
                
                Spacer()
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
    ProfileScreen()
}
