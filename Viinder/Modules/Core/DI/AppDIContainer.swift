//
//  SimpleContainer.swift
//  Viinder
//
//  Created by Wilver Muñoz on 19/07/25.
//
import Foundation

// MARK: - Simple Service Protocols
public protocol SimpleAnalyticsServiceProtocol {
    func track(event: String, parameters: [String: Any]?)
}

public protocol SimpleCrashlyticsServiceProtocol {
    func log(_ message: String)
}

public protocol SimpleNotificationServiceProtocol {
    func requestPermission() async throws -> Bool
}

// MARK: - Simple Service Implementations
public class SimpleAnalyticsService: SimpleAnalyticsServiceProtocol {
    public init() {}
    
    public func track(event: String, parameters: [String: Any]?) {
        print("📊 Analytics: \(event) - \(parameters ?? [:])")
    }
}

public class SimpleCrashlyticsService: SimpleCrashlyticsServiceProtocol {
    public init() {}
    
    public func log(_ message: String) {
        print("🔥 Crashlytics: \(message)")
    }
}

public class SimpleNotificationService: SimpleNotificationServiceProtocol {
    public init() {}
    
    public func requestPermission() async throws -> Bool {
        print("🔔 Notification permission requested")
        return true
    }
}

// MARK: - App DI Container
public final class AppDIContainer {
    public static let shared = AppDIContainer()
    
    private var services: [String: Any] = [:]
    private var singletons: [String: Any] = [:]
    
    private init() {
        registerDefaultServices()
    }
    
    // MARK: - Registration
    public func register<T>(_ type: T.Type, factory: @escaping () -> T) {
        let key = String(describing: type)
        services[key] = factory
    }
    
    public func registerSingleton<T>(_ type: T.Type, factory: @escaping () -> T) {
        let key = String(describing: type)
        services[key] = factory
    }
    
    // MARK: - Resolution
    public func resolve<T>(_ type: T.Type) -> T {
        let key = String(describing: type)
        
        // Check if it's a singleton and already created
        if let singleton = singletons[key] as? T {
            return singleton
        }
        
        // Get factory and create instance
        guard let factory = services[key] as? () -> T else {
            fatalError("Service of type \(type) not registered")
        }
        
        let instance = factory()
        
        // Store singleton if needed
        if services[key] != nil {
            singletons[key] = instance
        }
        
        return instance
    }
    
    // MARK: - Configuration
    public func setupForTesting() {
        registerMocks()
    }
    
    public func setupForPreviews() {
        registerMocks()
    }
    
    public func registerMocks() {
        print("🧪 Registering mock services for testing")
    }
    
    private func registerDefaultServices() {
        // Simple Services
        registerSingleton(SimpleAnalyticsService.self) { SimpleAnalyticsService() }
        registerSingleton(SimpleCrashlyticsService.self) { SimpleCrashlyticsService() }
        registerSingleton(SimpleNotificationService.self) { SimpleNotificationService() }
    }
    
    // MARK: - Validation
    public func validateDependencies() -> Bool {
        let requiredServices: [Any.Type] = [
            SimpleAnalyticsService.self,
            SimpleCrashlyticsService.self,
            SimpleNotificationService.self
        ]
        
        for serviceType in requiredServices {
            let key = String(describing: serviceType)
            guard services[key] != nil else {
                print("❌ Required service \(serviceType) not registered")
                return false
            }
        }
        
        print("✅ All required dependencies validated successfully")
        return true
    }
    
    // MARK: - Reset (for testing)
    public func reset() {
        services.removeAll()
        singletons.removeAll()
        registerDefaultServices()
    }
}

// MARK: - Convenience Extensions
public extension AppDIContainer {
    // Simple Services
    var analyticsService: SimpleAnalyticsService { resolve(SimpleAnalyticsService.self) }
    var crashlyticsService: SimpleCrashlyticsService { resolve(SimpleCrashlyticsService.self) }
    var notificationService: SimpleNotificationService { resolve(SimpleNotificationService.self) }
}
