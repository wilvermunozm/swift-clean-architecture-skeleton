# Sistema de Inyección de Dependencias - Viinder iOS

Este sistema de inyección de dependencias está basado en **AppDIContainer** y proporciona una forma moderna, type-safe y escalable para gestionar dependencias en la app Viinder.

**Filosofía**: Solo el esqueleto mínimo necesario. Los protocolos y servicios específicos se agregan en la feature/capa correspondiente cuando se necesiten realmente.

## 🎯 Características

- ✅ **Type-safe**: Compilación segura con tipos Swift
- ✅ **Modular**: Fácil de extender y mantener
- ✅ **Testing-friendly**: Soporte para mocks y testing
- ✅ **SwiftUI Integration**: Property wrappers para inyección
- ✅ **Performance**: Lazy loading y gestión de singletons
- ✅ **Cross-app**: Reutilizable en otros proyectos (sin prefijos Viinder)
- ✅ **Thread-safe**: Acceso seguro desde múltiples hilos

## 🏗️ Arquitectura Actual

```
Core/DI/
├── AppDIContainer.swift        # Contenedor principal de DI
├── DIConfiguration.swift       # Configuración y property wrappers
└── DI_README.md               # Esta documentación
```

## 🚀 Uso Básico

### 1. Inyección con Property Wrapper (Recomendado)

```swift
class MyViewModel: ObservableObject {
    @Inject(SimpleAnalyticsService.self) private var analytics
    @Inject(SimpleCrashlyticsService.self) private var crashlytics
    @Inject(SimpleNotificationService.self) private var notifications
    
    func trackUserAction() {
        analytics.track(event: "user_action", parameters: ["screen": "home"])
    }
    
    func logError(_ error: Error) {
        crashlytics.log("Error occurred: \(error.localizedDescription)")
    }
    
    func requestNotifications() async {
        do {
            let granted = try await notifications.requestPermission()
            analytics.track(event: "notification_permission", parameters: ["granted": granted])
        } catch {
            crashlytics.log("Failed to request notifications: \(error)")
        }
    }
}
```

### 2. Acceso Directo al Container

```swift
class MyService {
    private let container = SimpleContainer.shared
    
    func performAction() {
        // Usando convenience methods
        container.logAppEvent("service_action", parameters: ["timestamp": Date()])
        container.logMessage("Service action performed")
        
        // Acceso directo a servicios
        let analytics = container.analyticsService
        analytics.track(event: "direct_access", parameters: nil)
    }
}
```

### 3. SwiftUI Integration

```swift
struct MyView: View {
    @Inject(SimpleAnalyticsService.self) private var analytics
    
    var body: some View {
        VStack {
            Button("Track Event") {
                analytics.track(event: "button_tapped", parameters: ["view": "MyView"])
            }
        }
        .withDependencies() // Opcional: para configuraciones adicionales
    }
}
```

## 🧪 Testing y Previews

### Configuración para Tests

```swift
class MyViewModelTests: XCTestCase {
    override func setUp() {
        super.setUp()
        // Configura mocks para testing
        DIConfiguration.shared.setupDependencies(environment: .testing)
    }
    
    override func tearDown() {
        // Limpia el estado
        SimpleContainer.shared.reset()
        super.tearDown()
    }
    
    func testTrackEvent() {
        let viewModel = MyViewModel()
        viewModel.trackUserAction()
        // Los mocks se inyectan automáticamente
        // Assertions aquí
    }
}
```

### SwiftUI Previews

```swift
struct MyView_Previews: PreviewProvider {
    static var previews: some View {
        MyView()
            .onAppear {
                // Configura mocks para previews
                DIConfiguration.shared.setupDependencies(environment: .preview)
            }
    }
}
```

## 📋 Servicios Disponibles Actualmente

### Servicios Base (Implementados)
- `analyticsService: SimpleAnalyticsService` - Tracking de eventos y métricas
- `crashlyticsService: SimpleCrashlyticsService` - Logging y crash reporting
- `notificationService: SimpleNotificationService` - Gestión de notificaciones

### Convenience Methods
- `container.logAppEvent(_:parameters:)` - Método rápido para analytics
- `container.logMessage(_:)` - Método rápido para crashlytics
- `container.requestNotifications()` - Método rápido para notificaciones

## 🔧 Cómo Agregar Nuevos Servicios

### Paso 1: Definir el Protocolo del Servicio

```swift
// Crear archivo: PaymentService.swift
protocol PaymentServiceProtocol {
    func processPayment(amount: Double) async throws -> PaymentResult
    func getPaymentHistory() async throws -> [Payment]
}

// Definir modelos necesarios
struct PaymentResult {
    let success: Bool
    let transactionId: String
}

struct Payment {
    let id: String
    let amount: Double
    let date: Date
}
```

### Paso 2: Implementar el Servicio

```swift
class PaymentService: PaymentServiceProtocol {
    private let analytics: SimpleAnalyticsService
    private let crashlytics: SimpleCrashlyticsService
    
    init(analytics: SimpleAnalyticsService, crashlytics: SimpleCrashlyticsService) {
        self.analytics = analytics
        self.crashlytics = crashlytics
    }
    
    func processPayment(amount: Double) async throws -> PaymentResult {
        analytics.track(event: "payment_started", parameters: ["amount": amount])
        crashlytics.log("Processing payment for $\(amount)")
        
        // Simular procesamiento
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1 segundo
        
        let result = PaymentResult(success: true, transactionId: "txn_\(UUID().uuidString)")
        analytics.track(event: "payment_completed", parameters: ["transaction_id": result.transactionId])
        
        return result
    }
    
    func getPaymentHistory() async throws -> [Payment] {
        crashlytics.log("Fetching payment history")
        // Implementación real aquí
        return []
    }
}
```

### Paso 3: Registrar en SimpleContainer

```swift
// Extender SimpleContainer para agregar el nuevo servicio
extension SimpleContainer {
    private func registerPaymentService() {
        register(PaymentServiceProtocol.self) {
            PaymentService(
                analytics: self.analyticsService,
                crashlytics: self.crashlyticsService
            )
        }
    }
    
    // Convenience accessor
    var paymentService: PaymentServiceProtocol {
        resolve(PaymentServiceProtocol.self)
    }
}

// Actualizar registerDefaultServices() en SimpleContainer
private func registerDefaultServices() {
    // Servicios existentes...
    registerSingleton(SimpleAnalyticsService.self) { SimpleAnalyticsService() }
    registerSingleton(SimpleCrashlyticsService.self) { SimpleCrashlyticsService() }
    registerSingleton(SimpleNotificationService.self) { SimpleNotificationService() }
    
    // Nuevo servicio
    registerPaymentService()
}
```

### Paso 4: Crear Mock para Testing (Opcional)

```swift
class MockPaymentService: PaymentServiceProtocol {
    var shouldSucceed = true
    var mockPayments: [Payment] = []
    
    func processPayment(amount: Double) async throws -> PaymentResult {
        if shouldSucceed {
            return PaymentResult(success: true, transactionId: "mock-txn-123")
        } else {
            throw PaymentError.processingFailed
        }
    }
    
    func getPaymentHistory() async throws -> [Payment] {
        return mockPayments
    }
}

enum PaymentError: Error {
    case processingFailed
}
```

### Paso 5: Usar el Nuevo Servicio

#### Con Property Wrapper:
```swift
class CheckoutViewModel: ObservableObject {
    @Inject(PaymentServiceProtocol.self) private var paymentService
    @Published var isProcessing = false
    @Published var paymentResult: PaymentResult?
    
    func processPayment(amount: Double) async {
        isProcessing = true
        defer { isProcessing = false }
        
        do {
            let result = try await paymentService.processPayment(amount: amount)
            await MainActor.run {
                self.paymentResult = result
            }
        } catch {
            // Manejar error
            print("Payment failed: \(error)")
        }
    }
}
```

#### Con Acceso Directo:
```swift
class PaymentManager {
    private let container = SimpleContainer.shared
    
    func handlePayment(amount: Double) async {
        let paymentService = container.paymentService
        
        do {
            let result = try await paymentService.processPayment(amount: amount)
            container.logAppEvent("payment_success", parameters: [
                "amount": amount,
                "transaction_id": result.transactionId
            ])
        } catch {
            container.logMessage("Payment failed: \(error.localizedDescription)")
        }
    }
}
```

### Paso 6: Usar en SwiftUI

```swift
struct CheckoutView: View {
    @StateObject private var viewModel = CheckoutViewModel()
    @State private var amount: Double = 0
    
    var body: some View {
        VStack {
            TextField("Amount", value: $amount, format: .currency(code: "USD"))
            
            Button("Process Payment") {
                Task {
                    await viewModel.processPayment(amount: amount)
                }
            }
            .disabled(viewModel.isProcessing)
            
            if let result = viewModel.paymentResult {
                Text("Payment \(result.success ? "Successful" : "Failed")")
                Text("Transaction ID: \(result.transactionId)")
            }
        }
        .padding()
    }
}
```

### Configuración de Mocks para Testing

```swift
// Extender SimpleContainer para mocks
extension SimpleContainer {
    func registerMocksForTesting() {
        // Reemplazar servicios con mocks
        register(PaymentServiceProtocol.self) { MockPaymentService() }
        
        print("🧪 Mock services registered for testing")
    }
}

// Actualizar DIConfiguration para usar mocks
extension DIConfiguration {
    private func setupTestingDependencies() {
        SimpleContainer.shared.registerMocksForTesting()
        print("🧪 Testing dependencies configured")
    }
}

// Usar en tests:
class PaymentTests: XCTestCase {
    override func setUp() {
        super.setUp()
        DIConfiguration.shared.setupDependencies(environment: .testing)
    }
    
    func testPaymentProcessing() async {
        let viewModel = CheckoutViewModel()
        await viewModel.processPayment(amount: 100.0)
        
        XCTAssertNotNil(viewModel.paymentResult)
        XCTAssertTrue(viewModel.paymentResult?.success == true)
    }
}
```

## 🔄 Migración desde Código Legacy

### Antes (Sin DI)

```swift
class MyViewModel: ObservableObject {
    // Dependencias hardcodeadas - difícil de testear
    private let analytics = SomeAnalyticsSDK()
    private let crashlytics = SomeCrashlyticsSDK()
    
    func trackEvent() {
        analytics.track("event")
    }
}
```

### Después (Con DI)

```swift
class MyViewModel: ObservableObject {
    @Inject(SimpleAnalyticsService.self) private var analytics
    @Inject(SimpleCrashlyticsService.self) private var crashlytics
    
    func trackEvent() {
        analytics.track(event: "event", parameters: nil)
        // Testable, modular, maintainable
    }
}
```

## 📱 Ejemplos Prácticos de Uso

### Feature de Autenticación

```swift
class LoginViewModel: ObservableObject {
    @Inject(SimpleAnalyticsService.self) private var analytics
    @Inject(SimpleCrashlyticsService.self) private var crashlytics
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func login(email: String, password: String) async {
        isLoading = true
        analytics.track(event: "login_attempt", parameters: ["method": "email"])
        
        do {
            // Simular login
            try await Task.sleep(nanoseconds: 2_000_000_000)
            
            await MainActor.run {
                self.isLoading = false
                self.errorMessage = nil
            }
            
            analytics.track(event: "login_success", parameters: ["user_id": "123"])
            crashlytics.log("User logged in successfully")
            
        } catch {
            await MainActor.run {
                self.isLoading = false
                self.errorMessage = error.localizedDescription
            }
            
            analytics.track(event: "login_failure", parameters: ["error": error.localizedDescription])
            crashlytics.log("Login failed: \(error.localizedDescription)")
        }
    }
}
```

### Feature de Workout

```swift
class WorkoutViewModel: ObservableObject {
    @Inject(SimpleAnalyticsService.self) private var analytics
    @Inject(SimpleNotificationService.self) private var notifications
    
    @Published var workouts: [Workout] = []
    
    func loadWorkouts() {
        analytics.track(event: "workouts_loaded", parameters: ["count": workouts.count])
        
        // Simular carga de workouts
        workouts = [
            Workout(id: "1", name: "Morning Run", duration: 30),
            Workout(id: "2", name: "Strength Training", duration: 45)
        ]
    }
    
    func scheduleWorkoutReminder(for workout: Workout) async {
        do {
            let granted = try await notifications.requestPermission()
            if granted {
                analytics.track(event: "workout_reminder_scheduled", parameters: [
                    "workout_id": workout.id,
                    "workout_name": workout.name
                ])
            }
        } catch {
            analytics.track(event: "notification_permission_denied", parameters: nil)
        }
    }
}

struct Workout {
    let id: String
    let name: String
    let duration: Int // minutos
}
```

## 🎯 Mejores Prácticas

### 1. Usa Property Wrappers cuando sea posible
```swift
// ✅ Recomendado
@Inject(MyServiceProtocol.self) private var myService

// ❌ Evitar (solo cuando sea necesario)
private let myService = SimpleContainer.shared.resolve(MyServiceProtocol.self)
```

### 2. Registra servicios como singletons cuando sea apropiado
```swift
// Para servicios stateless o que deben ser únicos
registerSingleton(AnalyticsService.self) { AnalyticsService() }

// Para servicios que pueden tener múltiples instancias
register(DataProcessor.self) { DataProcessor() }
```

### 3. Usa protocolos para abstraer implementaciones
```swift
// ✅ Bueno - testeable y flexible
protocol UserServiceProtocol {
    func getUser(id: String) async throws -> User
}

// ❌ Malo - acoplado a implementación específica
class UserService {
    func getUser(id: String) async throws -> User { ... }
}
```

### 4. Crea mocks para testing
```swift
class MockUserService: UserServiceProtocol {
    var mockUser: User?
    var shouldThrowError = false
    
    func getUser(id: String) async throws -> User {
        if shouldThrowError {
            throw UserError.notFound
        }
        return mockUser ?? User.default
    }
}
```

## 🚀 Próximos Pasos

1. **Agregar más servicios base**: UserService, WorkoutService, AuthService
2. **Implementar Factory pattern**: Para servicios más complejos
3. **Agregar validaciones**: Para dependencias críticas
4. **Documentar patrones**: Para casos de uso específicos
5. **Crear templates**: Para acelerar la creación de nuevos servicios

## 📚 Recursos Adicionales

- [Swift Dependency Injection Best Practices](https://developer.apple.com/documentation/swift)
- [SwiftUI Architecture Patterns](https://developer.apple.com/documentation/swiftui)
- [Testing in Swift](https://developer.apple.com/documentation/xctest)

---

**Nota**: Este sistema está diseñado para crecer con la aplicación. Comienza simple y agrega complejidad solo cuando sea necesaria.
