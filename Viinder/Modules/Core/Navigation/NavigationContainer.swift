//
//  NavigationContainer.swift
//  Viinder
//
//  Created by Wilver Muñoz on 19/07/25.
//
import SwiftUI

struct NavigationContainer: View {
    @StateObject private var coordinator = AppNavigationCoordinator()
    @State private var isAuthenticated = false
    
    var body: some View {
        NavigationStack(path: $coordinator.navigationPath) {
            rootView
                .navigationDestination(for: NavigationRoute.self) { route in
                    NavigationFactory(coordinator: coordinator)
                        .createView(for: route)
                }
        }
        .environmentObject(coordinator)
        .environment(\.navigationCoordinator, coordinator)
        .onAppear {
            checkAuthenticationStatus()
        }
    }
    
    @ViewBuilder
    private var rootView: some View {
        if isAuthenticated {
            NavigationFactory(coordinator: coordinator)
                .createView(for: .home)
        } else {
            NavigationFactory(coordinator: coordinator)
                .createView(for: .welcome)
        }
    }
    
    private func checkAuthenticationStatus() {
        // TODO: Implement actual authentication check
        isAuthenticated = false
    }
}
