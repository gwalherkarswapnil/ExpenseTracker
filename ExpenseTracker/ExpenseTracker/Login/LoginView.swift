//
//  LoginView.swift
//  ExpenseTracker
//
//  Created by Swapnil Gwalherkar on 28/10/24.
//

import SwiftUI
struct LoginView: View {
    var theme: Theme
    @State private var userValidator: UserValidator = UserValidator()
    @State private var isSignedIn = false
    @State private var userName = ""
    private let coordinator = SignInWithAppleCoordinator()
    @State private var mobileNumber = ""
    @State private var password = ""
    @State private var validationMessage = ""
    @State private var isLoading = false
    @State private var showPassword = false
    @State private var rememberMe = false
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Text(LoginViewConstants.title)
                .multilineTextAlignment(.center)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.orange)
                .accessibility(label: Text("App title"))
            
            Image("app_icon")
                .resizable()
                .frame(width: 100, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(radius: 20)
                .accessibility(hidden: true)
            
            TextField(LoginViewConstants.mobileNumberPlaceholder, text: $mobileNumber)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 2)
                .keyboardType(.numberPad)
                .accessibility(label: Text("Mobile Number Field"))
            
            HStack {
                if showPassword {
                    TextField(LoginViewConstants.passwordPlaceholder, text: $password)
                } else {
                    SecureField(LoginViewConstants.passwordPlaceholder, text: $password)
                }
                
                Button(action: {
                    showPassword.toggle()
                }) {
                    Image(systemName: showPassword ? "eye.slash" : "eye")
                        .foregroundColor(.gray)
                }
                .accessibility(label: Text(showPassword ? "Hide Password" : "Show Password"))
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 2)
            
            if !validationMessage.isEmpty {
                Text(validationMessage)
                    .foregroundColor(.red)
                    .font(.caption)
                    .accessibility(label: Text("Validation Message: \(validationMessage)"))
            }
            
            Toggle(isOn: $rememberMe) {
                Text(LoginViewConstants.rememberMe)
                    .foregroundColor(.gray)
            }
            .padding(.horizontal)
            .accessibility(label: Text(LoginViewConstants.rememberMeToggle))
            
            Button(action: {
                handleLogin()
            }) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text(LoginViewConstants.loginButtonTitle)
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .cornerRadius(15)
                        .shadow(radius: 10)
                }
            }
            .background(LinearGradient(gradient: Gradient(colors: [theme.primaryColor, theme.secondaryColor]), startPoint: .leading, endPoint: .trailing))

            .frame(maxWidth: .infinity)
            .background(theme.primaryColor)
            .cornerRadius(10)
            .disabled(isLoading)
            
            Text(LoginViewConstants.forgotPassword)
                .foregroundColor(theme.secondaryColor)
                .font(.footnote)
                .padding(.top, 5)
                .onTapGesture {
                    // Handle forgot password action
                }
            
            VStack(spacing: 10) {
                SocialLoginButton(icon: Image("logo.facebook"), text: LoginViewConstants.facebookLogin, backgroundColor: .blue) {
                    handleFacebookLogin()
                }
                
                SocialLoginButton(icon: Image(systemName: "applelogo"), text: LoginViewConstants.appleLogin, backgroundColor: .black) {
                    handleAppleLogin()
                }
                
                SocialLoginButton(icon: Image("logo.google"), text: LoginViewConstants.googleLogin, backgroundColor: .gray) {
                    handleGoogleLogin()
                }
            }
            .padding(.top, 20)
            
            HStack {
                Text(LoginViewConstants.noAccountText)
                Button(LoginViewConstants.registerButtonTitle) {
                    // Navigate to RegisterView
                }
                .foregroundColor(theme.primaryColor)
            }
        }
        .padding()
        .background(theme.backgroundColor)
        .ignoresSafeArea()
        .onAppear {
            coordinator.onSignIn = { userID, name in
                self.userName = name
                self.isSignedIn = true
            }
        }
    }
    
    // MARK: - Helper Functions
    
    func handleLogin() {
        // Reset validation message
        validationMessage = ""
        
        // Validate inputs
        if !userValidator.isValidMobileNumber(mobileNumber) {
            validationMessage = LoginViewConstants.invalidMobileMessage
            return
        }
        
        if password.isEmpty {
            validationMessage = "Password cannot be empty"
            return
        }
        
        // Start loading
        isLoading = true
        
        // Simulate login process
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isLoading = false
            // Add login logic here
        }
    }
    
    func handleFacebookLogin() {
        // Facebook login implementation
    }
    
    func handleAppleLogin() {
        // Apple login implementation
        coordinator.handleSignInWithApple()
    }
    
    func handleGoogleLogin() {
        // Google login implementation
        coordinator.handleGoogleLogin()
    }
}


#Preview {
    LoginView(theme: Theme.orangeTheme)
}
