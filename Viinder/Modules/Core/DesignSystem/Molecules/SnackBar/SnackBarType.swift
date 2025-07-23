import SwiftUI

public enum SnackBarType: CaseIterable {
    case success
    case error
    case warning
    case info
    
    public var backgroundColor: Color {
        switch self {
        case .success:
            return Color.green.opacity(0.9)
        case .error:
            return Color.red.opacity(0.9)
        case .warning:
            return Color.orange.opacity(0.9)
        case .info:
            return Color.blue.opacity(0.9)
        }
    }
    
    public var iconName: String {
        switch self {
        case .success:
            return "checkmark.circle.fill"
        case .error:
            return "xmark.circle.fill"
        case .warning:
            return "exclamationmark.triangle.fill"
        case .info:
            return "info.circle.fill"
        }
    }
    
    public var textColor: Color {
        return .white
    }
    
    public var iconColor: Color {
        return .white
    }
}
