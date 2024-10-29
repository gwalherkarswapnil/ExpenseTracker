//
//  LoginView.swift
//  ExpenseTracker
//
//  Created by Swapnil on 28/10/24.
//

import SwiftUI
struct LoginView: View {
    var theme: Theme
    
    @State private var mobileNumber = ""
    @State private var password = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Text("Expense Tracker")
                .multilineTextAlignment(.center)
                .font(.largeTitle)
                .fontWeight(.bold)
            Image(systemName: "app.fill")
                .font(.system(size: 60))
                .foregroundColor(theme.primaryColor)
            
            TextField("Mobile Number", text: $mobileNumber)
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
                // Login action
            }) {
                Text("Login")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(theme.primaryColor)
                    .cornerRadius(10)
            }
            
            Text("Forgot Password?")
                .foregroundColor(theme.secondaryColor)
                .font(.footnote)
                .padding(.top, 5)
            
            // Social login buttons
            VStack(spacing: 10) {
                SocialLoginButton(icon: Image(systemName: "logo.facebook"), text: "Continue with Facebook", backgroundColor: .blue) {
                    handleFacebookLogin()
                }
                
                SocialLoginButton(icon: Image(systemName: "applelogo"), text: "Continue with Apple", backgroundColor: .black) {
                    handleAppleLogin()
                }
                
                SocialLoginButton(icon: Image(systemName: "logo.google"), text: "Continue with Google", backgroundColor: .red) {
                    handleGoogleLogin()
                }
            }
            .padding(.top, 20)
            
            
            HStack {
                Text("Don’t have an account?")
                Button("Register") {
                    // Navigate to RegisterView
                    
                }
                .foregroundColor(theme.primaryColor)
            }
        }
        .padding()
        .background(theme.backgroundColor)
        .ignoresSafeArea()
    }
    
    // Sample actions for social login
    func handleFacebookLogin() {
        // Facebook login implementation
    }
    
    func handleAppleLogin() {
        // Apple login implementation
    }
    
    func handleGoogleLogin() {
        // Google login implementation
    }
}


#Preview {
    LoginView(theme: Theme(backgroundColor: .blue, primaryColor: .accentColor, secondaryColor: .white))
}
