//
//  SignInWithAppleCoordinator.swift
//  ExpenseTracker
//
//  Created by Swapnil Gwalherkar on 04/11/24.
//

import Foundation
import AuthenticationServices
import SwiftUI
import GoogleSignIn
import GoogleSignInSwift
class SignInWithAppleCoordinator: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    var onSignIn: ((String, String) -> Void)?

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return UIApplication.shared.windows.first! // Adjust for your app’s setup
    }

    func handleSignInWithApple() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authController = ASAuthorizationController(authorizationRequests: [request])
        authController.delegate = self
        authController.presentationContextProvider = self
        authController.performRequests()
    }
    
    func handleGoogleLogin() {
        // Create a configuration object with the client ID
        let signInConfig = GIDConfiguration(clientID: "1067644037181-6f8qlgmjustcknrtuq75a5cfkme48ajf.apps.googleusercontent.com") // Replace with your actual client ID

        // Start the sign-in process
        GIDSignIn.sharedInstance.signIn(withPresenting: getRootViewController()) { result, error in
            print("Result \(result)")
        }
    }
    private func getRootViewController() -> UIViewController {
          // Traverse the view hierarchy to find the root view controller
          if let window = UIApplication.shared.windows.first {
              if let rootVC = window.rootViewController {
                  return rootVC
              }
          }
          return UIViewController() // Fallback
      }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName?.givenName ?? "User"
            onSignIn?(userIdentifier, fullName)
        }
    }

    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Sign in with Apple failed: \(error.localizedDescription)")
    }
}
