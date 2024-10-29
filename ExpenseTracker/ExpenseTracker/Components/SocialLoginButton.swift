//
//  SocialLoginButton.swift
//  ExpenseTracker
//
//  Created by Swapnil on 28/10/24.
//

import SwiftUI
/// A customizable social login button.
///
/// This view represents a button that can be used for social login options, such as
/// Facebook, Google, or Apple. It includes an icon and text, and allows customization
/// of the background color and action to be performed when the button is tapped.
///
/// - Parameters:
///   - icon: The image to be displayed on the button, representing the social login service.
///   - text: The text label for the button, describing the action (e.g., "Sign in with Facebook").
///   - backgroundColor: The background color of the button.
///   - action: The closure that is called when the button is tapped.

struct SocialLoginButton: View {
    let icon: Image
    let text: String
    let backgroundColor: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                icon
                    .resizable()
                    .frame(width: 24, height: 24)
                Text(text)
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.leading, 8)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(backgroundColor)
            .cornerRadius(8)
        }
    }
}

