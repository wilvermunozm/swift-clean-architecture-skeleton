//
//  Coordinaator.swift
//  Viinder
//
//  Created by Wilver Muñoz on 19/07/25.
//
import Foundation
import SwiftUI

// MARK: - Navigation Coordinator Protocol
@MainActor
protocol NavigationCoordinator: ObservableObject {
    var navigationPath: NavigationPath { get set }
    
    func navigate(to route: NavigationRoute)
    func navigateBack()
    func navigateToRoot()
    func replace(with route: NavigationRoute)
    func canNavigateBack() -> Bool
}

// MARK: - App Navigation Coordinator
@MainActor
final class AppNavigationCoordinator: NavigationCoordinator {
    @Published var navigationPath = NavigationPath()
    
    func navigate(to route: NavigationRoute) {
        navigationPath.append(route)
    }
    
    func navigateBack() {
        guard !navigationPath.isEmpty else { return }
        navigationPath.removeLast()
    }
    
    func navigateToRoot() {
        navigationPath = NavigationPath()
    }
    
    func replace(with route: NavigationRoute) {
        navigationPath = NavigationPath()
        navigationPath.append(route)
    }
    
    func canNavigateBack() -> Bool {
        return !navigationPath.isEmpty
    }
    
    func navigateToAuthFlow() {
        navigateToRoot()
    }
    
    func navigateToMainFlow() {
        replace(with: NavigationRoute.home)
    }
}

// MARK: - Navigation Environment
private struct NavigationCoordinatorKey: EnvironmentKey {
    static let defaultValue: AppNavigationCoordinator? = nil
}

extension EnvironmentValues {
    var navigationCoordinator: AppNavigationCoordinator? {
        get { self[NavigationCoordinatorKey.self] }
        set { self[NavigationCoordinatorKey.self] = newValue }
    }
}

extension View {
    func navigationCoordinator(_ coordinator: AppNavigationCoordinator) -> some View {
        environment(\.navigationCoordinator, coordinator)
    }
}


