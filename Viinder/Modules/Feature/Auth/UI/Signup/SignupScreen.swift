//
//  SignupScreen.swift
//  Viinder
//
//  Created by Wilver Muñoz on 19/07/25.
//
import SwiftUI

struct SignupScreen: View {
    @Environment(\.viinderTheme) private var theme
    @StateObject private var viewModel = SignupViewModel()
    
    var onSignupSuccess: () -> Void = {}
    var onLogin: () -> Void = {}
    var onBack: () -> Void = {}
    
    var body: some View {
        ZStack {
            // Background
            Color.black
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 0) {
                    // Header with confirmation text
                    VStack(spacing: 16) {
                        Text("Por favor, confirme y complete su identidad a continuación.")
                            .font(.title2)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                    }
                    .padding(.top, 60)
                    .padding(.bottom, 32)
                    
                    // Profile Avatar with Upload
                    ZStack {
                        Circle()
                            .fill(Color(red: 0.2, green: 0.7, blue: 0.7)) // Teal color from image
                            .frame(width: 120, height: 120)
                        
                        Image(systemName: "person.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.white)
                        
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                Button(action: {
                                    viewModel.uploadProfileImage()
                                }) {
                                    Circle()
                                        .fill(.white)
                                        .frame(width: 32, height: 32)
                                        .overlay(
                                            Image(systemName: "arrow.up")
                                                .font(.system(size: 14, weight: .medium))
                                                .foregroundColor(Color(red: 0.2, green: 0.7, blue: 0.7))
                                        )
                                        .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                                }
                                .offset(x: 8, y: 8)
                            }
                        }
                    }
                    .frame(width: 120, height: 120)
                    .padding(.bottom, 40)
                    
                    // General Section
                    VStack(spacing: 24) {
                        HStack {
                            Text("General")
                                .font(.title3)
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                            Spacer()
                        }
                        .padding(.horizontal, 24)
                        
                        VStack(spacing: 16) {
                            // Full Name Field
                            HStack(spacing: 12) {
                                Image(systemName: "person")
                                    .font(.system(size: 16))
                                    .foregroundColor(.gray)
                                    .frame(width: 20)
                                
                                TextField("Nombre Completo", text: $viewModel.fullName)
                                    .font(.body)
                                    .foregroundColor(.white)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.gray.opacity(0.15))
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                            .padding(.horizontal, 24)
                            
                            // Email Field
                            HStack(spacing: 12) {
                                Image(systemName: "envelope")
                                    .font(.system(size: 16))
                                    .foregroundColor(.gray)
                                    .frame(width: 20)
                                
                                TextField("Correo", text: $viewModel.email)
                                    .font(.body)
                                    .foregroundColor(.white)
                                    .keyboardType(.emailAddress)
                                    .autocapitalization(.none)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.gray.opacity(0.15))
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                            .padding(.horizontal, 24)
                            
                            // Password Field
                            HStack(spacing: 12) {
                                Image(systemName: "lock")
                                    .font(.system(size: 16))
                                    .foregroundColor(.gray)
                                    .frame(width: 20)
                                
                                SecureField("Contraseña", text: $viewModel.password)
                                    .font(.body)
                                    .foregroundColor(.white)
                                
                                Button(action: {
                                    // Toggle password visibility
                                }) {
                                    Image(systemName: "eye")
                                        .font(.system(size: 16))
                                        .foregroundColor(.gray)
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.gray.opacity(0.15))
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                            .padding(.horizontal, 24)
                        }
                    }
                    .padding(.bottom, 32)
                    
                    // Security Message
                    VStack(spacing: 12) {
                        Image(systemName: "lock.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.gray.opacity(0.7))
                        
                        Text("Tus datos personales y de fitness están seguros y nunca los compartiremos con nadie 😉")
                            .font(.caption)
                            .foregroundColor(.gray.opacity(0.8))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                    .padding(.bottom, 40)
                    
                    // Terms and Conditions Button
                    Button(action: {
                        viewModel.acceptedTerms.toggle()
                    }) {
                        HStack(spacing: 12) {
                            Text("Términos y condiciones")
                                .font(.body)
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            Image(systemName: viewModel.acceptedTerms ? "checkmark.circle.fill" : "circle")
                                .font(.system(size: 20))
                                .foregroundColor(viewModel.acceptedTerms ? Color(red: 0.2, green: 0.7, blue: 0.7) : .gray)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(red: 0.2, green: 0.7, blue: 0.7))
                        )
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 16)
                    
                    // Agreement Text
                    Text("Estoy de acuerdo con los término y condiciones.")
                        .font(.body)
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.bottom, 32)
                    
                    // Continue Button
                    Button(action: {
                        viewModel.signUp()
                        if viewModel.isFormValid {
                            onSignupSuccess()
                        }
                    }) {
                        HStack(spacing: 8) {
                            if viewModel.isLoading {
                                ProgressView()
                                    .scaleEffect(0.8)
                                    .tint(.black)
                            } else {
                                Text("Continue")
                                    .font(.body)
                                    .fontWeight(.semibold)
                                Image(systemName: "arrow.right")
                                    .font(.system(size: 16, weight: .medium))
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(viewModel.isFormValid ? Color(red: 0.0, green: 0.8, blue: 0.8) : Color.gray.opacity(0.5))
                        )
                        .foregroundColor(.black)
                    }
                    .disabled(!viewModel.isFormValid || viewModel.isLoading)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 24)
                    
                    // Login Link
                    HStack(spacing: 4) {
                        Text("¿Ya tienes cuenta?")
                            .font(.body)
                            .foregroundColor(.white)
                        
                        Button(action: onLogin) {
                            Text("Inicia")
                                .font(.body)
                                .fontWeight(.medium)
                                .foregroundColor(Color(red: 0.2, green: 0.7, blue: 0.7))
                                .underline()
                        }
                    }
                    .padding(.bottom, 40)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: onBack) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                }
            }
        }
        .alert("Error", isPresented: .constant(viewModel.errorMessage != nil)) {
            Button("OK") {
                viewModel.clearError()
            }
        } message: {
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
            }
        }
    }
}

#Preview {
    SignupScreen()
        .viinderTheme(.dark)
}
