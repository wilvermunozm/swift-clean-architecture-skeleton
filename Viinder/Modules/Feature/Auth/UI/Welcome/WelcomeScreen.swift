import SwiftUI

struct WelcomeScreen: View {
    @Environment(\.viinderTheme) private var theme
    
    var onGoogleLogin: () -> Void = {}
    var onAppleLogin: () -> Void = {}
    var onEmailLogin: () -> Void = {}
    var onRegister: () -> Void = {}
    
    var body: some View {
        AppScaffold(
            horizontalPadding: 0
        ) {
            GeometryReader { geometry in
                ZStack {
                    Image("img_welcome_background")
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .clipped()
                    
                    VStack {
                        Spacer()
                            .frame(height: 20)
                        
                        Image("LogoViinder")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 47)
                            .padding(.bottom, 24)
                            .foregroundColor(theme.colors.primary)
                            .padding(.top, 80)
                        
                        Text(NSLocalizedString("welcome_title", comment: ""))
                            .font(.workSansExtraBold(size: 36))
                            .foregroundColor(theme.colors.tertiary)
                            .frame(width: 350)
                        
                        Text(NSLocalizedString("welcome_subtitle", comment: ""))
                            .font(theme.typography.bodyLarge)
                            .foregroundColor(theme.colors.tertiary)
                            .padding(.top, 8)
                        
                        Spacer()
                        
                        VStack(spacing: 24) {
                            
                            OutlineButtonIcon(
                                title: NSLocalizedString("login_with_apple", comment: ""),
                                icon: Image("Apple"),
                                action: onAppleLogin
                            )
                            
                            OutlineButtonIcon(
                                title: NSLocalizedString(
                                    "login_with_google",
                                    comment: ""
                                ),
                                icon: Image("Google"),
                                action: onGoogleLogin
                            )
                            
                            PrimaryButton(
                                title: NSLocalizedString("login_with_email", comment: ""),
                                action: onEmailLogin,
                                icon: Image("Email"),
                                iconPosition: .left
                            )
                        }.padding(.horizontal, 16)
                        
                        HStack {
                            Text(NSLocalizedString("no_account_question", comment: ""))
                                .font(theme.typography.bodyMedium)
                                .foregroundColor(theme.colors.tertiary)
                            
                            Button(action: onRegister) {
                                Text(NSLocalizedString("register_action", comment: ""))
                                    .font(theme.typography.bodyMedium.bold())
                                    .foregroundColor(theme.colors.primary)
                                    .underline()
                            }
                        }
                        .padding(.top, 24)
                        .padding(.bottom, 32)
                    }
                }
            }
            .ignoresSafeArea()
        }
    }
}

#Preview {
    WelcomeScreen().viinderTheme(.dark).edgesIgnoringSafeArea(.all)
}
