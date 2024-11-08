//
//  RegisterView.swift
//  ExpenseTracker
//
//  Created by Swapnil Gwalherkar on 29/10/24.
//

import SwiftUI

struct RegisterView: View {
    var theme: Theme
    var userValidator = UserValidator()
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @State private var validationMessage = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image("app_icon")
                .resizable()
                .frame(width: 100, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(radius: 20)
            
            Group {
                TextField("Mobile Number", text: $username)
                TextField("Email", text: $email)
                SecureField("Password", text: $password)
            }
            .padding()
            .background(theme.backgroundColor.opacity(0.1))
            .cornerRadius(15)
            .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 5)
            .font(.body)
            .keyboardType(.emailAddress)
            .textInputAutocapitalization(.never)
            .disableAutocorrection(true)
            
            if !validationMessage.isEmpty {
                Text(validationMessage)
                    .foregroundColor(.red)
                    .font(.caption)
            }
            
            Button(action: {
                // Validation logic here
                if !userValidator.isValidMobileNumber(username) {
                    validationMessage = "Please enter a valid 10-digit mobile number"
                } else if !userValidator.isValidEmail(email) {
                    validationMessage = "Please enter a valid email address"
                } else if password.count < 8 {
                    validationMessage = "Password must be at least 8 characters long"
                } else {
                    validationMessage = ""
                    // Proceed with registration action
                }
            }) {
                Text("Register Now")
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(LinearGradient(gradient: Gradient(colors: [theme.primaryColor, theme.secondaryColor]), startPoint: .leading, endPoint: .trailing))
                    .cornerRadius(15)
                    .shadow(radius: 10)
            }
            
            Spacer()
            
            HStack {
                Text("Already have an account?")
                Button("Login") {
                    // Navigate to LoginView
                }
                .foregroundColor(theme.primaryColor)
            }
            .padding(.top, 10)
        }
        .padding()
        .background(theme.backgroundColor.ignoresSafeArea())
    }
}


#Preview {
    RegisterView(theme: Theme.orangeTheme)
}
