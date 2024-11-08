//
//  RegisterView.swift
//  ExpenseTracker
//
//  Created by Swapnil on 29/10/24.
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
            
            Image(systemName: "app.fill")
                .font(.system(size: 60))
                .foregroundColor(theme.primaryColor)
            
            TextField("Mobile Number", text: $username)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 2)
                .keyboardType(.numberPad)
            
            TextField("Email", text: $email)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 2)
                .keyboardType(.emailAddress)
            
            SecureField("Password", text: $password)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 2)
            
            if !validationMessage.isEmpty {
                Text(validationMessage)
                    .foregroundColor(.red)
                    .font(.caption)
            }
            
            Button(action: {
                // Validate fields before registration
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
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(theme.primaryColor)
                    .cornerRadius(10)
            }

            
            Spacer()
            
            HStack {
                Text("Already have an account?")
                Button("Login") {
                    // Navigate to LoginView
                }
                .foregroundColor(theme.primaryColor)
            }
        }
        .padding()
        .background(theme.backgroundColor)
        .ignoresSafeArea()
    }
    
}

#Preview {
    RegisterView(theme: Theme(backgroundColor: .blue, primaryColor: .accentColor, secondaryColor: .white))
}
