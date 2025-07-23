import SwiftUI

struct ForgotPasswordScreen: View {
    @Environment(\.viinderTheme) private var theme
    @State private var emailText: String = ""
    
    var onBack: () -> Void = {}
    var onResetSent: () -> Void = {}
    
    var body: some View {
        AppScaffold {
            VStack(spacing: 24) {
                VStack(spacing: 16) {
                    Text(NSLocalizedString("forgot_password_title", comment: ""))
                        .font(theme.typography.headlineLarge)
                        .foregroundColor(theme.colors.onBackground)
                    
                    Text(NSLocalizedString("forgot_password_subtitle", comment: ""))
                        .font(theme.typography.bodyLarge)
                        .foregroundColor(theme.colors.onSurface)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 40)
                
                InputField(
                    text: $emailText,
                    label: NSLocalizedString("email_label", comment: ""),
                    placeholder: NSLocalizedString("email_placeholder", comment: ""),
                    keyboardType: .emailAddress,
                    isEmail: true
                )
                
                Spacer()
                
                PrimaryButton(
                    title: NSLocalizedString("send_reset_link", comment: ""),
                    action: onResetSent
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
    ForgotPasswordScreen()
}
