import SwiftUI

struct OutlineButtonIcon: View {
    @Environment(\.viinderTheme) private var theme
    
    private let title: String
    private let icon: Image
    private let action: () -> Void
    
    init(title: String, icon: Image, action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack {
                Spacer()
                icon
                    .resizable()
                    .frame(width: 24, height: 24)
                
                Spacer().frame(width: 16)
                
                Text(title)
                    .font(theme.typography.labelLarge.bold())
                    .foregroundColor(theme.colors.onSurface)
                
                Spacer()
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity, minHeight: 48)
        }
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(theme.colors.outline, lineWidth: 1)
        )
    }
}
