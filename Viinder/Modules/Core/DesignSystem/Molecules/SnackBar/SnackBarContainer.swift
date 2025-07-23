import SwiftUI

// MARK: - SnackBar Container Overlay
public struct SnackBarContainer<Content: View>: View {
    let content: Content
    @StateObject private var snackBarManager = SnackBarManager.shared
    
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    public var body: some View {
        ZStack {
            content
                .environment(\.snackBarManager, snackBarManager)
            
            VStack {
                if snackBarManager.isPresented,
                   let currentSnackBar = snackBarManager.currentSnackBar {
                    CustomSnackBar(
                        snackBar: currentSnackBar,
                        onDismiss: {
                            snackBarManager.dismiss()
                        }
                    )
                    .transition(.asymmetric(
                        insertion: .move(edge: .top).combined(with: .opacity),
                        removal: .move(edge: .top).combined(with: .opacity)
                    ))
                    .zIndex(1000)
                }
                
                Spacer()
            }
            .allowsHitTesting(false)
        }
    }
}

// MARK: - View Extensions for Easy Usage
public extension View {
    /// Adds SnackBar functionality to any view
    func withSnackBar() -> some View {
        SnackBarContainer {
            self
        }
    }
    
    /// Shows a success snackbar
    func showSuccessSnackBar(
        title: String,
        message: String? = nil,
        duration: TimeInterval = 3.0,
        action: SnackBarAction? = nil
    ) {
        Task { @MainActor in
            SnackBarManager.shared.showSuccess(
                title: title,
                message: message,
                duration: duration,
                action: action
            )
        }
    }
    
    /// Shows an error snackbar
    func showErrorSnackBar(
        title: String,
        message: String? = nil,
        duration: TimeInterval = 4.0,
        action: SnackBarAction? = nil
    ) {
        Task { @MainActor in
            SnackBarManager.shared.showError(
                title: title,
                message: message,
                duration: duration,
                action: action
            )
        }
    }
    
    /// Shows a warning snackbar
    func showWarningSnackBar(
        title: String,
        message: String? = nil,
        duration: TimeInterval = 3.5,
        action: SnackBarAction? = nil
    ) {
        Task { @MainActor in
            SnackBarManager.shared.showWarning(
                title: title,
                message: message,
                duration: duration,
                action: action
            )
        }
    }
    
    /// Shows an info snackbar
    func showInfoSnackBar(
        title: String,
        message: String? = nil,
        duration: TimeInterval = 3.0,
        action: SnackBarAction? = nil
    ) {
        Task { @MainActor in
            SnackBarManager.shared.showInfo(
                title: title,
                message: message,
                duration: duration,
                action: action
            )
        }
    }
    
    /// Shows a custom snackbar
    func showSnackBar(_ snackBar: SnackBarModel) {
        Task { @MainActor in
            SnackBarManager.shared.show(snackBar)
        }
    }
}

// MARK: - Environment-based Extensions
public extension View {
    /// Shows snackbar using environment manager
    func showSnackBar(
        title: String,
        message: String? = nil,
        type: SnackBarType,
        duration: TimeInterval = 3.0,
        action: SnackBarAction? = nil
    ) -> some View {
        self.environment(\.snackBarManager, SnackBarManager.shared)
            .onAppear {
                let snackBar = SnackBarModel(
                    title: title,
                    message: message,
                    type: type,
                    duration: duration,
                    action: action
                )
                SnackBarManager.shared.show(snackBar)
            }
    }
}
