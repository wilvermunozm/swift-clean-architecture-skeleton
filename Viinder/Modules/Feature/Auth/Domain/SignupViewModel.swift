import SwiftUI
import Combine

@MainActor
class SignupViewModel: ObservableObject {
    @Published var fullName: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var acceptedTerms: Bool = false
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    var isFormValid: Bool {
        !fullName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        isValidEmail(email) &&
        password.count >= 6 &&
        acceptedTerms
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    func signUp() {
        guard isFormValid else {
            errorMessage = NSLocalizedString("signup_form_invalid", comment: "Please fill all fields correctly")
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        // Simulate API call
        Task {
            try await Task.sleep(nanoseconds: 2_000_000_000) // 2 seconds
            
            await MainActor.run {
                isLoading = false
                // Simulate success - in real app this would handle actual signup
                print("Signup successful for: \(email)")
            }
        }
    }
    
    func uploadProfileImage() {
        // Handle profile image upload
        print("Upload profile image tapped")
    }
    
    func clearError() {
        errorMessage = nil
    }
}
