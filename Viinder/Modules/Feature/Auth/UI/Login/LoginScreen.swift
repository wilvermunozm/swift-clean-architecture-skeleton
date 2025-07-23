//
//  LoginScreen.swift
//  Viinder
//
//  Created by Wilver Muñoz on 18/07/25.
//
import SwiftUI

struct LoginScreen: View {
    @Environment(\.viinderTheme) private var theme
    @State private var emailText: String = ""
    @State private var passwordText: String = ""
    
    var onLoginSuccess: () -> Void = {}
    var onForgotPassword: () -> Void = {}
    var onSignUp: () -> Void = {}
    var onBack: () -> Void = {}
    
    var body: some View {
        AppScaffold {
            VStack(spacing: 24) {
                VStack(spacing: 16) {
                    Text(NSLocalizedString("login_title", comment: ""))
                        .font(theme.typography.headlineLarge)
                        .foregroundColor(theme.colors.onBackground)
                    
                    Text(NSLocalizedString("login_subtitle", comment: ""))
                        .font(theme.typography.bodyLarge)
                        .foregroundColor(theme.colors.onSurface)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 40)
                
                VStack(spacing: 16) {
                    InputField(
                        text: $emailText,
                        label: NSLocalizedString("email_label", comment: ""),
                        placeholder: NSLocalizedString("email_placeholder", comment: ""),
                        keyboardType: .emailAddress,
                        isEmail: true
                    )
                    
                    InputField(
                        text: $passwordText,
                        label: NSLocalizedString("password_label", comment: ""),
                        placeholder: NSLocalizedString("password_placeholder", comment: ""),
                        isPassword: true
                    )
                    
                    HStack {
                        Spacer()
                        Button(action: onForgotPassword) {
                            Text(NSLocalizedString("forgot_password_action", comment: ""))
                                .font(theme.typography.bodyMedium)
                                .foregroundColor(theme.colors.primary)
                        }
                    }
                }
                
                Spacer()
                
                VStack(spacing: 16) {
                    PrimaryButton(
                        title: NSLocalizedString("login_action", comment: ""),
                        action: onLoginSuccess
                    )
                    
                    HStack {
                        Text(NSLocalizedString("no_account_question", comment: ""))
                            .font(theme.typography.bodyMedium)
                            .foregroundColor(theme.colors.onSurface)
                        
                        Button(action: onSignUp) {
                            Text(NSLocalizedString("signup_action", comment: ""))
                                .font(theme.typography.bodyMedium.bold())
                                .foregroundColor(theme.colors.primary)
                                .underline()
                        }
                    }
                }
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
    LoginScreen()
        .environment(\.viinderTheme, ViinderTheme.dark)
}
