import SwiftUI

public struct CustomSnackBar: View {
    let snackBar: SnackBarModel
    let onDismiss: () -> Void
    
    @State private var isVisible = false
    @State private var dragOffset: CGSize = .zero
    
    public init(snackBar: SnackBarModel, onDismiss: @escaping () -> Void) {
        self.snackBar = snackBar
        self.onDismiss = onDismiss
    }
    
    public var body: some View {
        HStack(spacing: 12) {
            // Icon
            Image(systemName: snackBar.type.iconName)
                .font(.title2)
                .foregroundColor(snackBar.type.iconColor)
            
            // Content
            VStack(alignment: .leading, spacing: 4) {
                Text(snackBar.title)
                    .font(.system(.subheadline, design: .rounded, weight: .semibold))
                    .foregroundColor(snackBar.type.textColor)
                
                if let message = snackBar.message {
                    Text(message)
                        .font(.system(.caption, design: .rounded))
                        .foregroundColor(snackBar.type.textColor.opacity(0.9))
                        .multilineTextAlignment(.leading)
                }
            }
            
            Spacer()
            
            // Action Button (if exists)
            if let action = snackBar.action {
                Button(action: {
                    action.action()
                    onDismiss()
                }) {
                    Text(action.title)
                        .font(.system(.caption, design: .rounded, weight: .medium))
                        .foregroundColor(snackBar.type.textColor)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.white.opacity(0.2))
                        )
                }
            }
            
            // Close Button
            Button(action: onDismiss) {
                Image(systemName: "xmark")
                    .font(.caption)
                    .foregroundColor(snackBar.type.textColor.opacity(0.8))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(snackBar.type.backgroundColor)
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        )
        .padding(.horizontal, 16)
        .offset(y: isVisible ? 0 : -100)
        .offset(y: dragOffset.height)
        .opacity(isVisible ? 1 : 0)
        .scaleEffect(isVisible ? 1 : 0.8)
        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: isVisible)
        .animation(.spring(response: 0.3, dampingFraction: 0.9), value: dragOffset)
        .gesture(
            DragGesture()
                .onChanged { value in
                    if value.translation.height < 0 {
                        dragOffset = value.translation
                    }
                }
                .onEnded { value in
                    if value.translation.height < -50 {
                        onDismiss()
                    } else {
                        dragOffset = .zero
                    }
                }
        )
        .onAppear {
            withAnimation {
                isVisible = true
            }
            
            // Auto dismiss after duration
            DispatchQueue.main.asyncAfter(deadline: .now() + snackBar.duration) {
                onDismiss()
            }
        }
        .onDisappear {
            isVisible = false
            dragOffset = .zero
        }
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 20) {
        CustomSnackBar(
            snackBar: .success(title: "Success!", message: "Your action was completed successfully."),
            onDismiss: {}
        )
        
        CustomSnackBar(
            snackBar: .error(title: "Error", message: "Something went wrong. Please try again."),
            onDismiss: {}
        )
        
        CustomSnackBar(
            snackBar: .warning(title: "Warning", message: "Please check your input."),
            onDismiss: {}
        )
        
        CustomSnackBar(
            snackBar: .info(
                title: "Info",
                message: "New update available",
                action: SnackBarAction(title: "Update") {}
            ),
            onDismiss: {}
        )
    }
    .padding()
    .background(Color.gray.opacity(0.1))
}
