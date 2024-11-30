//
//  RegisterView.swift
//  ExpenseTracker
//
//  Created by Swapnil Gwalherkar on 29/10/24.
//

import SwiftUI
import SwiftUI
import SwiftUI

// Custom View Modifiers
struct FieldStyle: ViewModifier {
    var backgroundColor: Color = .white
    var height: CGFloat = 40
    
    func body(content: Content) -> some View {
        content
            .padding(.horizontal)
            .frame(height: height)
            .background(backgroundColor)
            .cornerRadius(20)
            .shadow(radius: 5)
    }
}

struct ButtonStyle: ViewModifier {
    var gradient: LinearGradient
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(.white)
            .fontWeight(.bold)
            .padding()
            .frame(maxWidth: .infinity)
            .background(gradient)
            .cornerRadius(15)
            .shadow(radius: 10)
    }
}

struct TitleStyle: ViewModifier {
    var color: Color
    
    func body(content: Content) -> some View {
        content
            .fontWeight(.bold)
            .foregroundColor(color)
            .shadow(color: .black, radius: 2, x: 1, y: 1)
    }
}

struct RegisterView: View {
    var theme: Theme
    var userValidator = UserValidator()
    
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @State private var validationMessage = ""
    
    @FocusState private var focusedField: Field?
    
    enum Field: Hashable {
        case username, email, password
    }

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 20) {
                Text(LoginViewConstants.title)
                    .modifier(TitleStyle(color: theme.primaryColor)) // Apply custom title modifier
                    .padding(.top, 50)
                    .appFont(size: 32, weight: .bold)  // Custom font with size 32
                    .fontWeight(.bold)

                Image("app_icon")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(radius: 20)

                // Fields Group
                Group {
                    TextField("Mobile Number", text: $username)
                        .focused($focusedField, equals: .username)
                        .modifier(FieldStyle()) // Apply custom field modifier
                        .keyboardType(.numberPad)
                        .textInputAutocapitalization(.never)
                        .disableAutocorrection(true)

                    TextField("Email", text: $email)
                        .focused($focusedField, equals: .email)
                        .modifier(FieldStyle()) // Apply custom field modifier
                        .keyboardType(.emailAddress)

                    SecureField("Password", text: $password)
                        .focused($focusedField, equals: .password)
                        .modifier(FieldStyle()) // Apply custom field modifier
                }
                .padding(.horizontal)  // Ensure consistent horizontal padding

                if !validationMessage.isEmpty {
                    Text(validationMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding(.horizontal)
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
                        .modifier(ButtonStyle(gradient: LinearGradient(gradient: Gradient(colors: [theme.primaryColor, theme.secondaryColor]), startPoint: .leading, endPoint: .trailing))) // Apply custom button modifier
                }
                .padding(.bottom, 30)

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
            .padding([.leading, .trailing])  // Ensure horizontal padding for the entire VStack
            .background(theme.backgroundColor.ignoresSafeArea())
            .padding(.bottom, focusedField != nil ? geometry.safeAreaInsets.bottom : 0)  // Adjust view when keyboard is visible
            .onTapGesture {
                // Dismiss keyboard when tapping outside fields
                focusedField = nil
            }
        }
        .onAppear {
            // Hide keyboard when navigating away from the screen
            focusedField = nil
        }
    }
}

#Preview {
    RegisterView(theme: Theme.orangeTheme)
}


#Preview {
    RegisterView(theme: Theme.orangeTheme)
}
