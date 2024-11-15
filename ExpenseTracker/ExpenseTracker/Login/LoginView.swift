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
    @State private var navigateToHome = false
    @State private var navigateToRegister = false

    var body: some View {
        NavigationStack {
            ScrollView () {
                VStack(spacing: 20) {
                    Text(LoginViewConstants.title)
                        .appFont(size: 32, weight: .bold)
                        .foregroundColor(theme.primaryColor)
                        .padding(.top, 50)
                    
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
                        .appFont(size: 18)
                    
                    HStack {
                        if showPassword {
                            TextField(LoginViewConstants.passwordPlaceholder, text: $password)
                                .appFont(size: 18)
                        } else {
                            SecureField(LoginViewConstants.passwordPlaceholder, text: $password)
                                .appFont(size: 18)
                        }
                        
                        Button(action: {
                            showPassword.toggle()
                        }) {
                            Image(systemName: showPassword ? "eye.slash" : "eye")
                                .foregroundColor(.gray)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 2)
                    
                    if !validationMessage.isEmpty {
                        Text(validationMessage)
                            .appFont(size: 14)
                            .foregroundColor(.red)
                    }
                    
                    Toggle(isOn: $rememberMe) {
                        Text(LoginViewConstants.rememberMe)
                            .appFont(size: 16)
                            .foregroundColor(.gray)
                    }
                    .tint(theme.primaryColor)
                    .padding(.horizontal)
                    
                    Button(action: {
                        handleLogin()
                    }) {
                        ZStack {
                            LinearGradient(gradient: Gradient(colors: [theme.primaryColor, theme.secondaryColor]), startPoint: .leading, endPoint: .trailing)
                                .cornerRadius(10)
                                .frame(height: 50)
                            
                            Text(LoginViewConstants.loginButtonTitle)
                                .appFont(size: 18, weight: .semibold)
                                .foregroundColor(.white)
                                .opacity(isLoading ? 0.5 : 1.0)
                                .padding()
                                .frame(maxWidth: .infinity)
                            
                            if isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            }
                        }
                        .frame(height: 50)
                        .cornerRadius(10)
                        .shadow(radius: 10)
                    }
                    .disabled(isLoading)
                    
                    Text(LoginViewConstants.forgotPassword)
                        .appFont(size: 16, weight: .bold)
                        .foregroundColor(theme.secondaryColor)
                        .padding(.top, 5)
                    
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
                            navigateToRegister = true
                        }
                        .foregroundColor(theme.primaryColor)
                    }
                    .navigationDestination(isPresented: $navigateToRegister) {
                        RegisterView(theme: theme)
                            .navigationBarBackButtonHidden(false)
                    }
                    .navigationDestination(isPresented: $navigateToHome) {
                        HomeContentView()
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
            .ignoresSafeArea()
        }
    }

    // MARK: - Helper Functions
    
    func handleLogin() {
        // Reset validation message
        validationMessage = ""
        
        // Validate inputs
//        if !userValidator.isValidMobileNumber(mobileNumber) {
//            validationMessage = LoginViewConstants.invalidMobileMessage
//            return
//        }
//
//        if password.isEmpty {
//            validationMessage = "Password cannot be empty"
//            return
//        }
        
        // Start loading with 1-second delay
        isLoading = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            isLoading = false
            // After loading, navigate to Home View
            navigateToHome = true
        }
    }
    
    func handleFacebookLogin() {
        // Facebook login implementation
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            isLoading = false
            // After loading, navigate to Home View
            navigateToHome = true
        }
        
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
