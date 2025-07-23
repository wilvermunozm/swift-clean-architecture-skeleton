//
//  NavigationFactory.swift
//  Viinder
//
//  Created by Wilver Muñoz on 19/07/25.
//
import SwiftUI


struct NavigationFactory {
    @ObservedObject private var coordinator: AppNavigationCoordinator
    
    init(coordinator: AppNavigationCoordinator) {
        self.coordinator = coordinator
    }
    
    @ViewBuilder
    func createView(for route: NavigationRoute) -> some View {
        switch route {
        case .welcome:
            WelcomeScreen(
                onGoogleLogin: { coordinator.navigate(to: .login) },
                onAppleLogin: { coordinator.navigate(to: .login) },
                onEmailLogin: { coordinator.navigate(to: .login) },
                onRegister: { coordinator.navigate(to: .signup) }
            )
            
        case .login:
            LoginScreen(
                onLoginSuccess: { coordinator.navigateToMainFlow() },
                onForgotPassword: { coordinator.navigate(to: .forgotPassword) },
                onSignUp: { coordinator.navigate(to: .signup) },
                onBack: { coordinator.navigateBack() }
            )
            
        case .signup:
            SignupScreen(
                onSignupSuccess: { coordinator.navigateToMainFlow() },
                onLogin: { coordinator.navigate(to: .login) },
                onBack: { coordinator.navigateBack() }
            )
            
        case .forgotPassword:
            ForgotPasswordScreen(
                onBack: { coordinator.navigateBack() },
                onResetSent: { coordinator.navigateBack() }
            )
            
        case .home:
            HomeScreen()
                .environment(\.navigationCoordinator, coordinator)
            
        case .profile:
            ProfileScreen(
                onBack: { coordinator.navigateBack() }
            )
            
        case .settings:
            SettingsScreen(
                onBack: { coordinator.navigateBack() },
                onLogout: { coordinator.navigateToAuthFlow() }
            )
        }
    }
}
