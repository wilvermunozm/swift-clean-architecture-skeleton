//
//  ViinderLogger.swift
//  Viinder
//
//  Created by Wilver Muñoz on 19/07/25.
//

import Foundation
import OSLog
import SwiftUI

// MARK: - Log Level
public enum ViinderLogLevel: String, CaseIterable {
    case debug = "DEBUG"
    case info = "INFO"
    case warning = "WARNING"
    case error = "ERROR"
    case critical = "CRITICAL"
    
    var osLogType: OSLogType {
        switch self {
        case .debug: return .debug
        case .info: return .info
        case .warning: return .default
        case .error: return .error
        case .critical: return .fault
        }
    }
    
    var emoji: String {
        switch self {
        case .debug: return "🔍"
        case .info: return "ℹ️"
        case .warning: return "⚠️"
        case .error: return "❌"
        case .critical: return "🚨"
        }
    }
}

// MARK: - Log Category
public enum ViinderLogCategory: String, CaseIterable {
    case app = "App"
    case ui = "UI"
    case navigation = "Navigation"
    case network = "Network"
    case database = "Database"
    case auth = "Authentication"
    case workout = "Workout"
    case social = "Social"
    case performance = "Performance"
    case security = "Security"
    case analytics = "Analytics"
    
    var subsystem: String { "com.mawiapps.viinder" }
    var category: String { self.rawValue }
}

// MARK: - Viinder Logger
@MainActor
public final class ViinderLogger {
    public static let shared = ViinderLogger()
    
    private var loggers: [ViinderLogCategory: OSLog] = [:]
    private let dateFormatter: DateFormatter
    
    private init() {
        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        setupLoggers()
    }
    
    private func setupLoggers() {
        for category in ViinderLogCategory.allCases {
            loggers[category] = OSLog(subsystem: category.subsystem, category: category.category)
        }
    }
    
    private func getLogger(for category: ViinderLogCategory) -> OSLog {
        return loggers[category] ?? OSLog.default
    }
    
    public func log(
        level: ViinderLogLevel,
        message: String,
        category: ViinderLogCategory = .app,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        let logger = getLogger(for: category)
        let fileName = URL(fileURLWithPath: file).lastPathComponent
        let timestamp = dateFormatter.string(from: Date())
        
        let logMessage = "\(level.emoji) [\(level.rawValue)] \(timestamp) \(fileName):\(line) \(function) - \(message)"
        
        os_log("%{public}@", log: logger, type: level.osLogType, logMessage)
        
        #if DEBUG
        print(logMessage)
        #endif
    }
    
    public func debug(
        _ message: String,
        category: ViinderLogCategory = .app,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        log(level: .debug, message: message, category: category, file: file, function: function, line: line)
    }
    
    public func info(
        _ message: String,
        category: ViinderLogCategory = .app,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        log(level: .info, message: message, category: category, file: file, function: function, line: line)
    }
    
    public func warning(
        _ message: String,
        category: ViinderLogCategory = .app,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        log(level: .warning, message: message, category: category, file: file, function: function, line: line)
    }
    
    public func error(
        _ message: String,
        category: ViinderLogCategory = .app,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        log(level: .error, message: message, category: category, file: file, function: function, line: line)
    }
    
    public func critical(
        _ message: String,
        category: ViinderLogCategory = .app,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        log(level: .critical, message: message, category: category, file: file, function: function, line: line)
    }
    
    public func logAppLaunch() {
        info(
            "App launched",
            category: .app
        )
    }
    
    public func logUserAction(_ action: String, category: ViinderLogCategory = .ui) {
        info("User action: \(action)", category: category)
    }
    
    public func logPerformance(operation: String, duration: TimeInterval, category: ViinderLogCategory = .performance) {
        let level: ViinderLogLevel = duration > 1.0 ? .warning : .info
        log(
            level: level,
            message: "Performance: \(operation) took \(String(format: "%.2f", duration * 1000))ms",
            category: category
        )
    }
}

// MARK: - Simple Error Handler
@MainActor
public final class AppErrorHandler: ObservableObject {
    public static let shared = AppErrorHandler()
    
    @Published public var currentError: Error?
    @Published public var showErrorAlert = false
    
    private init() {}
    
    public func handle(
        _ error: Error,
        context: String? = nil,
        file: String = #file,
        function: String = #function,
        line: Int = #line,
        showAlert: Bool = true
    ) {
        let contextMessage = context.map { " Context: \($0)" } ?? ""
        let errorMessage = "Error: \(error.localizedDescription)\(contextMessage)"
        
        ViinderLogger.shared.error(
            errorMessage,
            category: .app,
            file: file,
            function: function,
            line: line
        )
        
        if showAlert {
            currentError = error
            showErrorAlert = true
        }
    }
    
    public func dismissError() {
        currentError = nil
        showErrorAlert = false
    }
}

// MARK: - SwiftUI Extensions
public extension View {
    func appErrorHandler() -> some View {
        self.environmentObject(AppErrorHandler.shared)
            .alert("Error", isPresented: Binding<Bool>(
                get: { AppErrorHandler.shared.showErrorAlert },
                set: { _ in AppErrorHandler.shared.dismissError() }
            )) {
                Button("OK") {
                    AppErrorHandler.shared.dismissError()
                }
            } message: {
                if let error = AppErrorHandler.shared.currentError {
                    Text(error.localizedDescription)
                }
            }
    }
    
    func logUserAction(_ action: String, category: ViinderLogCategory = .ui) -> some View {
        self.onAppear {
            ViinderLogger.shared.logUserAction(action, category: category)
        }
    }
}

// MARK: - Performance Utilities
@MainActor
public func withViinderLogging<T>(
    operation: String,
    category: ViinderLogCategory = .app,
    showAlert: Bool = true,
    _ block: () throws -> T
) -> T? {
    do {
        let startTime = CFAbsoluteTimeGetCurrent()
        let result = try block()
        let duration = CFAbsoluteTimeGetCurrent() - startTime
        
        ViinderLogger.shared.logPerformance(
            operation: operation,
            duration: duration,
            category: category
        )
        
        return result
    } catch {
        AppErrorHandler.shared.handle(
            error,
            context: operation,
            showAlert: showAlert
        )
        return nil
    }
}
