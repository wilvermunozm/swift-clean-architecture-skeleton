//
//  ViinderApp.swift
//  Viinder
//
//  Created by Wilver Muñoz on 16/07/25.
//

import SwiftUI

@main
struct ViinderApp: App {
    
    init() {
        AppInitializationService.shared.initialize()
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationContainer()
                .viinderTheme(.dark)
                .edgesIgnoringSafeArea(.all)
                .appErrorHandler()
        }
    }
}
