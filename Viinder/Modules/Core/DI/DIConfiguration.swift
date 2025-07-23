import Foundation
import SwiftUI

public final class DIConfiguration {
    public static let shared = DIConfiguration()
    
    private init() {}
    
    public func setupDependencies(environment: AppEnvironment = .production) {
        switch environment {
        case .production:
            setupProductionDependencies()
        case .testing:
            setupTestingDependencies()
        case .preview:
            setupPreviewDependencies()
        }
        
        print("✅ DI configured for environment: \(environment)")
    }
    
    private func setupProductionDependencies() {
        print("🏭 Production dependencies configured")
    }
    
    private func setupTestingDependencies() {
        AppDIContainer.shared.setupForTesting()
        print("🧪 Testing dependencies configured")
    }
    
    private func setupPreviewDependencies() {
        AppDIContainer.shared.setupForPreviews()
        print("👁️ Preview dependencies configured")
    }
}

// MARK: - App Environment
public enum AppEnvironment {
    case production
    case testing
    case preview
}

// MARK: - Property Wrapper for Dependency Injection
@propertyWrapper
public struct Inject<T> {
    private let type: T.Type
    
    public init(_ type: T.Type) {
        self.type = type
    }
    
    public var wrappedValue: T {
        AppDIContainer.shared.resolve(type)
    }
}

// MARK: - SwiftUI Integration
public extension View {
    func withDependencies() -> some View {
        self
    }
}

// MARK: - Usage Examples for Simple Services
public extension AppDIContainer {
    func logAppEvent(_ event: String, parameters: [String: Any]? = nil) {
        analyticsService.track(event: event, parameters: parameters)
    }
    
    func logMessage(_ message: String) {
        crashlyticsService.log(message)
    }
    
    func requestNotifications() async throws -> Bool {
        return try await notificationService.requestPermission()
    }
}
