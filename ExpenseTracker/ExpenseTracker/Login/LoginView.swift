//
//  LoginView.swift
//  ExpenseTracker
//
//  Created by Swapnil Gwalherkar on 28/10/24.
//

import SwiftUI
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
    @State private var navigateToChat = false  // New state for navigation to ChatView

    var body: some View {
        NavigationStack {
            ScrollView() {
                VStack(spacing: 16) {
                    // Header Section
                    VStack(spacing: 12) {
                  
                        Text(LoginViewConstants.title)
                            .appFont(size: 24, weight: .medium)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.2), radius: 1, x: 0, y: 1)
                        
                        Image("app_icon")
                            .resizable()
                            .frame(width: 80, height: 80)
                            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                            .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                            .accessibility(hidden: true)
                    }
                    .padding(.top, 30)
                    
                    // Login Form Card
                    VStack(spacing: 16) {
                        // Input Fields
                        VStack(spacing: 12) {
                            TextField(LoginViewConstants.mobileNumberPlaceholder, text: $mobileNumber)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(Color(.systemGray6))
                                .cornerRadius(12)
                                .keyboardType(.numberPad)
                                .appFont(size: 16)
                            
                            HStack {
                                if showPassword {
                                    TextField(LoginViewConstants.passwordPlaceholder, text: $password)
                                        .appFont(size: 16)
                                } else {
                                    SecureField(LoginViewConstants.passwordPlaceholder, text: $password)
                                        .appFont(size: 16)
                                }
                                
                                Button(action: {
                                    showPassword.toggle()
                                }) {
                                    Image(systemName: showPassword ? "eye.slash" : "eye")
                                        .foregroundColor(.gray)
                                        .font(.subheadline)
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                        }
                        
                        if !validationMessage.isEmpty {
                            Text(validationMessage)
                                .appFont(size: 12)
                                .foregroundColor(.red)
                        }
                        
                        HStack {
                            Toggle(isOn: $rememberMe) {
                                Text(LoginViewConstants.rememberMe)
                                    .appFont(size: 14)
                                    .foregroundColor(.secondary)
                            }
                            .tint(theme.primaryColor)
                        }
                        
                        Button(action: {
                            handleLogin()
                        }) {
                            ZStack {
                                LinearGradient(
                                    gradient: Gradient(colors: [theme.primaryColor, theme.secondaryColor]), 
                                    startPoint: .leading, 
                                    endPoint: .trailing
                                )
                                .cornerRadius(12)
                                .frame(height: 44)
                                
                                Text(LoginViewConstants.loginButtonTitle)
                                    .appFont(size: 16, weight: .semibold)
                                    .foregroundColor(.white)
                                    .opacity(isLoading ? 0.5 : 1.0)
                                
                                if isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .scaleEffect(0.8)
                                }
                            }
                            .frame(height: 44)
                            .shadow(color: theme.primaryColor.opacity(0.3), radius: 4, x: 0, y: 2)
                        }
                        .disabled(isLoading)
                        
                        Button(action: {
                            // Handle forgot password
                        }) {
                            Text(LoginViewConstants.forgotPassword)
                                .appFont(size: 14, weight: .medium)
                                .foregroundColor(theme.secondaryColor)
                        }
                        .padding(.top, 4)
                    }
                    .padding(20)
                    .background(Color(.systemBackground))
                    .cornerRadius(16)
                    .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
                    .padding(.horizontal, 16)
                    
                    // Social Login Section
                    VStack(spacing: 8) {
                        Text("or continue with")
                            .appFont(size: 14)
                            .foregroundColor(.secondary)
                            .padding(.bottom, 4)
                        
                        CompactSocialLoginButton(icon: Image("logo.facebook"), text: "Facebook", color: .blue) {
                            handleFacebookLogin()
                        }
                        
                        CompactSocialLoginButton(icon: Image(systemName: "applelogo"), text: "Apple", color: .black) {
                            handleAppleLogin()
                        }
                        
                        CompactSocialLoginButton(icon: Image("logo.google"), text: "Google", color: .gray) {
                            handleGoogleLogin()
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
                    
                    // Bottom Navigation
                    HStack(spacing: 4) {
                        Text(LoginViewConstants.noAccountText)
                            .appFont(size: 14)
                            .foregroundColor(.secondary)
                        
                        Button(LoginViewConstants.registerButtonTitle) {
                            navigateToRegister = true
                        }
                        .appFont(size: 14, weight: .semibold)
                        .foregroundColor(theme.primaryColor)
                    }
                    .padding(.top, 16)
                    
                    // Debug Chat Button (remove in production)
                    Button(action: {
                        navigateToChat = true
                    }) {
                        Text("Go to Chat")
                            .appFont(size: 14, weight: .medium)
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [theme.primaryColor, theme.secondaryColor]), 
                                    startPoint: .leading, 
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(8)
                            .shadow(color: theme.primaryColor.opacity(0.3), radius: 3, x: 0, y: 1)
                    }
                    .padding(.top, 8)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 20)
                .padding(.top, 58)

            }
            .background(
                LinearGradient(
                    colors: [theme.primaryColor, theme.secondaryColor, theme.backgroundColor],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .ignoresSafeArea()
            .navigationDestination(isPresented: $navigateToRegister) {
                RegisterView(theme: theme)
                    .navigationBarBackButtonHidden(false)
            }
            .navigationDestination(isPresented: $navigateToHome) {
                HomeContentView()
            }
            .navigationDestination(isPresented: $navigateToChat) {
                ChatView()
            }
            .onAppear {
                coordinator.onSignIn = { userID, name in
                    self.userName = name
                    self.isSignedIn = true
                }
            }
        }
    }

    // MARK: - Helper Functions
    
    func handleLogin() {
        // Reset validation message
        validationMessage = ""
        
        // Validate inputs
        // Your validation logic

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
           // navigateToHome = true
            coordinator.handleFacebookLogin()
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

// MARK: - Compact Social Login Button Component
struct CompactSocialLoginButton: View {
    let icon: Image
    let text: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                icon
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 18, height: 18)
                    .foregroundColor(.white)
                
                Text(text)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(color)
            .cornerRadius(12)
            .shadow(color: color.opacity(0.3), radius: 3, x: 0, y: 1)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    LoginView(theme: Theme.orangeTheme)
}
