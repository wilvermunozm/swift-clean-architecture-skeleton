import Foundation

public struct SnackBarModel: Identifiable, Equatable {
    public let id = UUID()
    public let title: String
    public let message: String?
    public let type: SnackBarType
    public let duration: TimeInterval
    public let action: SnackBarAction?
    
    public init(
        title: String,
        message: String? = nil,
        type: SnackBarType,
        duration: TimeInterval = 3.0,
        action: SnackBarAction? = nil
    ) {
        self.title = title
        self.message = message
        self.type = type
        self.duration = duration
        self.action = action
    }
    
    public static func == (lhs: SnackBarModel, rhs: SnackBarModel) -> Bool {
        return lhs.id == rhs.id
    }
}

public struct SnackBarAction: Equatable {
    public let title: String
    public let action: () -> Void
    
    public init(title: String, action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }
    
    public static func == (lhs: SnackBarAction, rhs: SnackBarAction) -> Bool {
        return lhs.title == rhs.title
    }
}

// MARK: - Convenience Initializers
public extension SnackBarModel {
    static func success(
        title: String,
        message: String? = nil,
        duration: TimeInterval = 3.0,
        action: SnackBarAction? = nil
    ) -> SnackBarModel {
        return SnackBarModel(title: title, message: message, type: .success, duration: duration, action: action)
    }
    
    static func error(
        title: String,
        message: String? = nil,
        duration: TimeInterval = 4.0,
        action: SnackBarAction? = nil
    ) -> SnackBarModel {
        return SnackBarModel(title: title, message: message, type: .error, duration: duration, action: action)
    }
    
    static func warning(
        title: String,
        message: String? = nil,
        duration: TimeInterval = 3.5,
        action: SnackBarAction? = nil
    ) -> SnackBarModel {
        return SnackBarModel(title: title, message: message, type: .warning, duration: duration, action: action)
    }
    
    static func info(
        title: String,
        message: String? = nil,
        duration: TimeInterval = 3.0,
        action: SnackBarAction? = nil
    ) -> SnackBarModel {
        return SnackBarModel(title: title, message: message, type: .info, duration: duration, action: action)
    }
}
