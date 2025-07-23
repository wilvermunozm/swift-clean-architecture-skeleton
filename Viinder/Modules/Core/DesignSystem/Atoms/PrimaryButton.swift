import SwiftUI

enum IconPosition {
    case none, left, right
}

struct PrimaryButton: View {
    @Environment(\.viinderTheme) private var theme
    
    private let text: String
    private let action: () -> Void
    private let icon: Image?
    private let iconPosition: IconPosition
    private let isLoading: Bool
    private let enabled: Bool
    
    init(
        title: String,
        action: @escaping () -> Void,
        icon: Image? = nil,
        iconPosition: IconPosition = .none,
        isLoading: Bool = false,
        enabled: Bool = true
    ) {
        self.text = title
        self.action = action
        self.icon = icon
        self.iconPosition = iconPosition
        self.isLoading = isLoading
        self.enabled = enabled
    }
    
    var body: some View {
        Button(action: action) {
            ZStack {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: theme.colors.onPrimary))
                        .frame(width: 24, height: 24)
                } else {
                    Group {
                        switch (icon, iconPosition) {
                        case (let icon?, .left):
                            HStack(spacing: 12) {
                                icon
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 16, height: 16)
                                    .foregroundColor(theme.colors.onPrimary)
                                
                                Text(text)
                                    .font(theme.typography.labelLarge)
                                    .foregroundColor(theme.colors.onPrimary)
                            }
                            
                        case (let icon?, .right):
                            HStack(spacing: 12) {
                                Text(text)
                                    .font(theme.typography.labelLarge)
                                    .foregroundColor(theme.colors.onPrimary)
                                
                                icon
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 16, height: 16)
                                    .foregroundColor(theme.colors.onPrimary)
                            }
                            
                        default:
                            Text(text)
                                .font(theme.typography.labelLarge)
                                .foregroundColor(theme.colors.onPrimary)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, minHeight: 48)
            .contentShape(Rectangle())
        }
        .background(
            enabled && !isLoading
            ? theme.colors.primary
            : theme.colors.surfaceVariant
        )
        .foregroundColor(
            enabled && !isLoading
            ? theme.colors.onPrimary
            : theme.colors.onSurfaceVariant
        )
        .cornerRadius(16)
        .disabled(!enabled || isLoading)
    }
}

#Preview {
    PrimaryButton(
        title: "Iniciar sesión con email",
        action: {},
        icon: Image("Email"),
        iconPosition: .left
    )
}
