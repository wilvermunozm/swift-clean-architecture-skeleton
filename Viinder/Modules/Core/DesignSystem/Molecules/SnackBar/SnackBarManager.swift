import SwiftUI
import Combine

@MainActor
public final class SnackBarManager: ObservableObject {
    public static let shared = SnackBarManager()
    
    @Published public var currentSnackBar: SnackBarModel?
    @Published public var isPresented = false
    
    private var dismissTimer: Timer?
    
    private init() {}
    
    public func show(_ snackBar: SnackBarModel) {
        dismissTimer?.invalidate()
        
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            currentSnackBar = snackBar
            isPresented = true
        }
        
        dismissTimer = Timer.scheduledTimer(withTimeInterval: snackBar.duration, repeats: false) { _ in
            Task { @MainActor in
                self.dismiss()
            }
        }
    }
    
    public func dismiss() {
        dismissTimer?.invalidate()
        dismissTimer = nil
        
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            isPresented = false
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.currentSnackBar = nil
        }
    }
    
    // MARK: - Convenience Methods
    public func showSuccess(
        title: String,
        message: String? = nil,
        duration: TimeInterval = 3.0,
        action: SnackBarAction? = nil
    ) {
        show(.success(title: title, message: message, duration: duration, action: action))
    }
    
    public func showError(
        title: String,
        message: String? = nil,
        duration: TimeInterval = 4.0,
        action: SnackBarAction? = nil
    ) {
        show(.error(title: title, message: message, duration: duration, action: action))
    }
    
    public func showWarning(
        title: String,
        message: String? = nil,
        duration: TimeInterval = 3.5,
        action: SnackBarAction? = nil
    ) {
        show(.warning(title: title, message: message, duration: duration, action: action))
    }
    
    public func showInfo(
        title: String,
        message: String? = nil,
        duration: TimeInterval = 3.0,
        action: SnackBarAction? = nil
    ) {
        show(.info(title: title, message: message, duration: duration, action: action))
    }
}

// MARK: - Environment Key
private struct SnackBarManagerKey: EnvironmentKey {
    static let defaultValue: SnackBarManager = SnackBarManager.shared
}

public extension EnvironmentValues {
    var snackBarManager: SnackBarManager {
        get { self[SnackBarManagerKey.self] }
        set { self[SnackBarManagerKey.self] = newValue }
    }
}
