//
//  InputField.swift
//  Viinder
//
//  Created by Wilver Muñoz on 18/07/25.
//

import SwiftUI

struct InputField: View {
    @Binding var text: String
    let label: String
    var placeholder: String = ""
    var keyboardType: UIKeyboardType = .default
    var isPassword: Bool = false
    var isEmail: Bool = false
    var singleLine: Bool = true
    var enabled: Bool = true
    
    @State private var passwordVisible: Bool = false
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.body.weight(.semibold))
                .foregroundColor(Color("TertiaryColor"))
            
            HStack(spacing: 8) {
                if let iconName = leadingIconName {
                    Image(systemName: iconName)
                        .foregroundColor(Color("TertiaryColor"))
                        .frame(width: 24, height: 24)
                }
                
                Group {
                    if isPassword && !passwordVisible {
                        SecureField(placeholder, text: $text)
                            .keyboardType(keyboardType)
                            .disabled(!enabled)
                            .foregroundColor(Color("TertiaryColor"))
                    } else {
                        TextField(placeholder, text: $text)
                            .keyboardType(keyboardType)
                            .disabled(!enabled)
                            .foregroundColor(Color("TertiaryColor"))
                    }
                }
                .font(.body)
                .lineLimit(singleLine ? 1 : nil)
                
                if isPassword {
                    Button(action: {
                        passwordVisible.toggle()
                    }) {
                        Image(systemName: passwordVisible ? "eye" : "eye.slash")
                            .foregroundColor(Color("TertiaryColor").opacity(0.3))
                            .frame(width: 24, height: 24)
                    }
                }
            }
            .padding()
            .frame(height: 52)
            .background(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(isFocused ? Color("PrimaryColor") : Color(.gray), lineWidth: 2)
                        )
            .focused($isFocused)
                        .animation(.easeInOut, value: isFocused)
                        .padding()
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        isFocused ? Color("PrimaryColor") : Color("OnSurfaceVariantColor").opacity(0.3),
                        lineWidth: 1
                    )
            )
        }
    }
    
    private var leadingIconName: String? {
        if isEmail {
            return "envelope"
        } else if isPassword {
            return "lock"
        } else {
            return nil
        }
    }
}

struct InputField_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            InputField(
                text: .constant(""),
                label: "Correo electrónico",
                placeholder: "Ingresa tu correo",
                keyboardType: .emailAddress,
                isEmail: true
            )
            .padding()
            
            InputField(
                text: .constant("password123"),
                label: "Contraseña",
                placeholder: "Ingresa tu contraseña",
                isPassword: true
            )
            .padding()
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}

