//
//  RegisterView.swift
//  ExpenseTracker
//
//  Created by Swapnil on 29/10/24.
//

import SwiftUI

struct RegisterView: View {
    var theme: Theme
    
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    
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
            
            TextField("Email", text: $email)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 2)
            
            SecureField("Password", text: $password)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 2)
            
            Button(action: {
                // Register action
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
