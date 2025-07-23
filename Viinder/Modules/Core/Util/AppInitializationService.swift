//
//  AppInitializationService.swift
//  Viinder
//
//  Created by Wilver Muñoz on 18/07/25.
//

import SwiftUI

class AppInitializationService {
    
    static let shared = AppInitializationService()
    
    private init() {}
    
    @MainActor func initialize() {
        setupLogging()
        setupLibraries()
        setupDependencyInjection()
    }
    
    @MainActor private func setupLogging() {
        ViinderLogger.shared.logAppLaunch()
        ViinderLogger.shared.info("Viinder app initialized", category: .app)
        ViinderLogger.shared.info("Logging system configured", category: .app)
    }
    
    @MainActor private func setupLibraries() {
        // TODO: Initialize other libraries here (Analytics, Crashlytics, etc.)
        ViinderLogger.shared.debug("Libraries setup completed", category: .app)
    }
    
    private func setupDependencyInjection() {
            print("🔧 Setting up dependency injection")
            
            DIConfiguration.shared.setupDependencies()
            
            print("✅ Dependency injection setup completed")
        }
}
