# Viinder Navigation System

## Overview

The Viinder navigation system is built using SwiftUI's NavigationStack and implements the Coordinator pattern for scalable, clean navigation management. This system provides a centralized way to handle navigation throughout the app while maintaining separation of concerns.

## Architecture Components

### 1. NavigationRoute (Enum)
Defines all possible navigation destinations in the app:
```swift
enum NavigationRoute: Hashable, CaseIterable {
    case welcome
    case login
    case signup
    case forgotPassword
    case home
    case profile
    case settings
}
```

### 2. AppNavigationCoordinator (Class)
Manages navigation state and provides navigation methods:
```swift
@MainActor
final class AppNavigationCoordinator: NavigationCoordinator {
    @Published var navigationPath = NavigationPath()
    
    func navigate(to route: NavigationRoute)
    func navigateBack()
    func navigateToRoot()
    func replace(with route: NavigationRoute)
    func canNavigateBack() -> Bool
}
```

### 3. NavigationContainer (View)
The root navigation container that wraps your app:
```swift
struct NavigationContainer: View {
    @StateObject private var coordinator = AppNavigationCoordinator()
    
    var body: some View {
        NavigationStack(path: $coordinator.navigationPath) {
            // Root view and navigation destinations
        }
    }
}
```

### 4. NavigationFactory (Struct)
Creates views for each navigation route:
```swift
struct NavigationFactory {
    func createView(for route: NavigationRoute) -> some View {
        switch route {
        case .welcome:
            WelcomeScreen(...)
        case .login:
            LoginScreen(...)
        // ... other cases
        }
    }
}
```

## Usage

### Setting up the Navigation System

1. **Replace your main app view with NavigationContainer:**
```swift
@main
struct ViinderApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationContainer()
        }
    }
}
```

2. **Access the coordinator in any view:**
```swift
struct MyView: View {
    @Environment(\.navigationCoordinator) private var coordinator
    
    var body: some View {
        Button("Go to Profile") {
            coordinator?.navigate(to: .profile)
        }
    }
}
```

### Adding New Screens

To add a new screen to the navigation system:

1. **Add a new case to NavigationRoute:**
```swift
enum NavigationRoute: Hashable, CaseIterable {
    // ... existing cases
    case newScreen
    
    var id: String {
        switch self {
        // ... existing cases
        case .newScreen:
            return "newScreen"
        }
    }
    
    var title: String {
        switch self {
        // ... existing cases
        case .newScreen:
            return NSLocalizedString("new_screen_title", comment: "")
        }
    }
}
```

2. **Add the view creation logic to NavigationFactory:**
```swift
func createView(for route: NavigationRoute) -> some View {
    switch route {
    // ... existing cases
    case .newScreen:
        NewScreen(
            onBack: { coordinator.navigateBack() }
        )
    }
}
```

3. **Create your new screen view:**
```swift
struct NewScreen: View {
    @Environment(\.viinderTheme) private var theme
    
    var onBack: () -> Void = {}
    
    var body: some View {
        AppScaffold {
            // Your screen content
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: onBack) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(theme.colors.onBackground)
                }
            }
        }
    }
}
```

4. **Navigate to your new screen from anywhere:**
```swift
coordinator?.navigate(to: .newScreen)
```

## Navigation Methods

### Basic Navigation
- `navigate(to: .screenName)` - Push a new screen onto the stack
- `navigateBack()` - Pop the current screen
- `navigateToRoot()` - Pop to the root screen
- `replace(with: .screenName)` - Replace the entire stack with a new screen

### Authentication Flow
- `navigateToAuthFlow()` - Navigate to authentication screens
- `navigateToMainFlow()` - Navigate to main app screens after login

## Best Practices

1. **Always use callbacks for navigation actions in screens**
2. **Hide the default back button and provide custom navigation**
3. **Use the coordinator for all navigation, don't mix with NavigationLink**
4. **Keep navigation logic in the coordinator, not in individual views**
5. **Use meaningful route names that describe the destination**

## Example Integration

```swift
// In your screen
struct LoginScreen: View {
    @Environment(\.viinderTheme) private var theme
    
    var onLoginSuccess: () -> Void = {}
    var onSignUp: () -> Void = {}
    var onBack: () -> Void = {}
    
    var body: some View {
        AppScaffold {
            VStack {
                // Login form
                
                PrimaryButton(
                    title: "Login",
                    action: onLoginSuccess
                )
                
                Button("Sign Up", action: onSignUp)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: onBack) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(theme.colors.onBackground)
                }
            }
        }
    }
}

// In NavigationFactory
case .login:
    LoginScreen(
        onLoginSuccess: { coordinator.navigateToMainFlow() },
        onSignUp: { coordinator.navigate(to: .signup) },
        onBack: { coordinator.navigateBack() }
    )
```

This navigation system provides a scalable, maintainable way to handle navigation throughout the Viinder app while following SwiftUI best practices and the Coordinator pattern.
