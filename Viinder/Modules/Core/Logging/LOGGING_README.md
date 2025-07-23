# Viinder Logging & Error Handling System

## Overview

This is a comprehensive, scalable, and native logging system built for the Viinder iOS app. It uses Apple's native OS Logger framework and provides centralized error handling with automatic alerts and performance monitoring.

## Features

- **Native OS Logger Integration**: Uses Apple's unified logging system
- **Centralized Error Handling**: Single point for all error management with automatic user alerts
- **Multiple Log Levels**: Debug, Info, Warning, Error, Critical with emojis
- **Categorized Logging**: Organized by app modules (UI, Network, Auth, Workout, etc.)
- **Performance Monitoring**: Built-in performance tracking with duration logging
- **SwiftUI Extensions**: Easy-to-use View modifiers and utilities
- **Clean Architecture**: Single file implementation for simplicity

## Architecture

```
Core/Logging/
├── ViinderLogger.swift         # Complete logging system
└── LOGGING_README.md          # This documentation
```

**Simple and Clean**: Everything you need in one file - `ViinderLogger.swift`

## Quick Start Guide for New Developers

### 1. Basic Logging

```swift
// Simple logging - use anywhere in your code
ViinderLogger.shared.info("User logged in successfully")
ViinderLogger.shared.error("Failed to load user data")
ViinderLogger.shared.debug("Debug information")
ViinderLogger.shared.warning("Something might be wrong")
ViinderLogger.shared.critical("Critical system error")

// With categories - organize your logs
ViinderLogger.shared.info("API request started", category: .network)
ViinderLogger.shared.debug("Button tapped", category: .ui)
ViinderLogger.shared.error("Authentication failed", category: .auth)
ViinderLogger.shared.info("Workout started", category: .workout)
```

### 2. Error Handling with Try/Catch

**This is the most important part for new developers!**

```swift
// ✅ RECOMMENDED: Use in all your try/catch blocks
func loginUser(email: String, password: String) async {
    do {
        let user = try await authService.login(email: email, password: password)
        ViinderLogger.shared.info("User logged in successfully", category: .auth)
        // Handle success
    } catch {
        // 🎯 This automatically logs the error AND shows user alert
        AppErrorHandler.shared.handle(
            error, 
            context: "User login with email: \(email)"
        )
    }
}

// ✅ Network requests
func fetchWorkouts() async {
    do {
        let workouts = try await networkService.getWorkouts()
        ViinderLogger.shared.info("Fetched \(workouts.count) workouts", category: .network)
        return workouts
    } catch {
        AppErrorHandler.shared.handle(
            error, 
            context: "Fetching user workouts",
            showAlert: true  // Shows alert to user
        )
    }
}

// ✅ Database operations
func saveWorkout(_ workout: Workout) {
    do {
        try database.save(workout)
        ViinderLogger.shared.info("Workout saved: \(workout.name)", category: .database)
    } catch {
        AppErrorHandler.shared.handle(
            error, 
            context: "Saving workout: \(workout.name)"
        )
    }
}

// ✅ Silent error handling (no user alert)
func trackAnalytics(event: String) {
    do {
        try analyticsService.track(event)
    } catch {
        // Log error but don't bother user
        AppErrorHandler.shared.handle(
            error, 
            context: "Analytics tracking: \(event)",
            showAlert: false  // Don't show alert for analytics
        )
    }
}
```

### 3. Performance Monitoring

```swift
// ✅ Wrap slow operations to track performance
func loadUserData() async {
    let result = withViinderLogging(
        operation: "Load User Profile",
        category: .performance
    ) {
        // Your slow operation here
        return database.fetchUserProfile()
    }
}

// ✅ Track specific user actions
func onLoginButtonTapped() {
    ViinderLogger.shared.logUserAction("login_button_tapped", category: .ui)
    // Handle login
}

// ✅ Manual performance logging
func complexCalculation() {
    let startTime = CFAbsoluteTimeGetCurrent()
    
    // Your complex operation
    performComplexOperation()
    
    let duration = CFAbsoluteTimeGetCurrent() - startTime
    ViinderLogger.shared.logPerformance(
        operation: "Complex Calculation",
        duration: duration,
        category: .performance
    )
}
```

### 4. SwiftUI Integration

```swift
// ✅ Add error handling to your entire app
struct ViinderApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationContainer()
                .appErrorHandler()  // 🎯 Add this to handle all errors
        }
    }
}

// ✅ Track user actions in views
struct WelcomeScreen: View {
    var body: some View {
        VStack {
            Button("Login") {
                loginUser()
            }
            .logUserAction("login_button_tapped", category: .ui)
            
            Button("Sign Up") {
                signUpUser()
            }
            .logUserAction("signup_button_tapped", category: .ui)
        }
    }
}

// ✅ Log screen appearances
struct ProfileScreen: View {
    var body: some View {
        VStack {
            // Your content
        }
        .onAppear {
            ViinderLogger.shared.logUserAction("profile_screen_appeared", category: .ui)
        }
    }
}
```

## Log Categories

Use the right category to organize your logs:

```swift
// 🏠 General app events
ViinderLogger.shared.info("App launched", category: .app)

// 🎨 User interface interactions
ViinderLogger.shared.debug("Button tapped", category: .ui)

// 🧭 Navigation events
ViinderLogger.shared.info("Navigated to profile", category: .navigation)

// 🌐 Network operations
ViinderLogger.shared.error("API call failed", category: .network)

// 💾 Database operations
ViinderLogger.shared.info("User saved", category: .database)

// 🔐 Authentication
ViinderLogger.shared.warning("Login attempt failed", category: .auth)

// 💪 Workout features
ViinderLogger.shared.info("Workout completed", category: .workout)

// 👥 Social features
ViinderLogger.shared.debug("Friend request sent", category: .social)

// ⚡ Performance monitoring
ViinderLogger.shared.warning("Slow operation detected", category: .performance)

// 🔒 Security events
ViinderLogger.shared.critical("Security breach detected", category: .security)

// 📊 Analytics and tracking
ViinderLogger.shared.info("Event tracked", category: .analytics)
```

## Common Patterns for New Developers

### ✅ DO - Good Logging Practices

```swift
// ✅ Always add context to your logs
ViinderLogger.shared.error("Failed to save workout: \(workout.name)", category: .database)

// ✅ Use appropriate log levels
ViinderLogger.shared.debug("User tapped button")     // Development info
ViinderLogger.shared.info("User logged in")          // Important events
ViinderLogger.shared.warning("Slow network detected") // Potential issues
ViinderLogger.shared.error("API call failed")        // Recoverable errors
ViinderLogger.shared.critical("Database corrupted")   // Critical problems

// ✅ Always handle errors in try/catch
do {
    try riskyOperation()
} catch {
    AppErrorHandler.shared.handle(error, context: "Performing risky operation")
}

// ✅ Log user actions for analytics
ViinderLogger.shared.logUserAction("workout_started", category: .workout)
```

### ❌ DON'T - Bad Practices

```swift
// ❌ Don't log sensitive information
ViinderLogger.shared.debug("User password: \(password)") // NEVER!

// ❌ Don't ignore errors silently
do {
    try riskyOperation()
} catch {
    // Silent failure - BAD!
}

// ❌ Don't use wrong log levels
ViinderLogger.shared.critical("Button tapped") // Too severe!
ViinderLogger.shared.debug("Database corrupted") // Too low!

// ❌ Don't log without context
ViinderLogger.shared.error("Failed") // What failed?
```

## Real-World Examples

### 🔐 Authentication Flow

```swift
func authenticateUser(email: String, password: String) async {
    ViinderLogger.shared.info("Starting authentication for: \(email)", category: .auth)
    
    do {
        let user = try await authService.login(email: email, password: password)
        ViinderLogger.shared.info("Authentication successful for user: \(user.id)", category: .auth)
        ViinderLogger.shared.logUserAction("user_logged_in", category: .auth)
    } catch {
        AppErrorHandler.shared.handle(
            error,
            context: "Authentication failed for: \(email)"
        )
    }
}
```

### 💪 Workout Management

```swift
func saveWorkout(_ workout: Workout) async {
    ViinderLogger.shared.info("Saving workout: \(workout.name)", category: .workout)
    
    let result = withViinderLogging(
        operation: "Save Workout to Database",
        category: .performance
    ) {
        do {
            try database.save(workout)
            ViinderLogger.shared.info("Workout saved successfully: \(workout.id)", category: .database)
            ViinderLogger.shared.logUserAction("workout_saved", category: .workout)
            return true
        } catch {
            AppErrorHandler.shared.handle(
                error,
                context: "Saving workout: \(workout.name)"
            )
            return false
        }
    }
}
```

### 🌐 Network Requests

```swift
func fetchUserProfile() async -> UserProfile? {
    ViinderLogger.shared.info("Fetching user profile", category: .network)
    
    do {
        let profile = try await networkService.getUserProfile()
        ViinderLogger.shared.info("User profile fetched successfully", category: .network)
        return profile
    } catch {
        AppErrorHandler.shared.handle(
            error,
            context: "Fetching user profile",
            showAlert: true  // Show error to user
        )
        return nil
    }
}
```

## Viewing Your Logs

### 🖥️ During Development

1. **Xcode Console**: Logs appear automatically in Xcode console with emojis
2. **Console.app**: Open macOS Console app and filter by `com.mawiapps.viinder`
3. **Simulator**: All logs visible in real-time

### 📱 Production/TestFlight

1. **Xcode Organizer**: Download logs from App Store Connect
2. **Device Console**: Settings > Privacy & Security > Analytics & Improvements
3. **External Services**: When integrated (Crashlytics, Sentry, etc.)

### 🔍 Log Format

Logs appear in this format:
```
🔍 [DEBUG] 2025-07-19 20:00:01.123 WelcomeScreen.swift:45 loginButtonTapped() - User tapped login button
ℹ️ [INFO] 2025-07-19 20:00:02.456 AuthService.swift:23 login() - User logged in successfully
❌ [ERROR] 2025-07-19 20:00:03.789 NetworkService.swift:67 fetchData() - Network request failed
```

## Setup Instructions

### 🚀 Already Set Up!

The logging system is already configured in your app:

1. **ViinderApp.swift** - Clean and minimal
2. **AppInitializationService.swift** - Handles all logging setup
3. **ViinderLogger.swift** - Complete logging system

### 🎯 Just Start Using It!

```swift
// In any file, just import and use:
ViinderLogger.shared.info("Your message here")
AppErrorHandler.shared.handle(error, context: "What you were doing")
```

### 📋 Quick Checklist for New Developers

- ✅ Add `.appErrorHandler()` to your main app view
- ✅ Use `AppErrorHandler.shared.handle()` in all try/catch blocks
- ✅ Log important user actions with `logUserAction()`
- ✅ Use appropriate categories (`.network`, `.ui`, `.auth`, etc.)
- ✅ Never log sensitive information (passwords, tokens, etc.)
- ✅ Add context to your error messages

### 🔧 Need Help?

Check the examples above or ask a senior developer. The logging system is designed to be simple and foolproof!

---

**Remember**: Good logging makes debugging 10x easier. Use it everywhere! 🚀

## Viewing Logs

### Development
- Console output: Logs appear in Xcode console
- Console.app: Use macOS Console app to view system logs
- Filter by subsystem: `com.mawiapps.viinder`

### Production
- Xcode Organizer: Download logs from TestFlight/App Store
- External Services: Crashlytics, Sentry dashboards
- Device Console: Settings > Privacy & Security > Analytics & Improvements

## Testing

```swift
// In unit tests
func testErrorHandling() {
    let expectation = XCTestExpectation(description: "Error logged")
    
    // Configure test logger
    LoggingManager.shared.configure(with: .testing)
    
    // Test error handling
    let error = AppError.network(.noConnection)
    ErrorHandler.shared.handle(error)
    
    // Verify error was handled
    XCTAssertEqual(ErrorHandler.shared.currentError, error)
}
```

## Migration Guide

If you're adding logging to existing code:

1. **Replace print statements**:
   ```swift
   // Old
   print("User logged in")
   
   // New
   AppLogger.shared.info("User logged in", category: .auth)
   ```

2. **Centralize error handling**:
   ```swift
   // Old
   catch {
       showAlert(error.localizedDescription)
   }
   
   // New
   catch {
       ErrorHandler.shared.handle(error, context: "User login")
   }
   ```

3. **Add performance monitoring**:
   ```swift
   // Old
   let result = expensiveOperation()
   
   // New
   let result = withLogging(operation: "Expensive Operation") {
       return expensiveOperation()
   }
   ```

This logging system provides a solid foundation for monitoring, debugging, and maintaining the Viinder app throughout its lifecycle.
