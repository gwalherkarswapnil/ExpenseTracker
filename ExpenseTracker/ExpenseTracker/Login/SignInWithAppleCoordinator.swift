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
import FacebookLogin
import Combine

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

    func handleFacebookLogin() {
        // Create a configuration object with the client ID
        facebookLogin()
    }
    
    let loginManager = LoginManager()
    func facebookLogin() {
        LoginManager()
            .logIn(permissions: [.publicProfile, .email])
            .flatMap { loginResult -> AnyPublisher<Account?, Error> in
                switch loginResult {
                case .failed(let error):
                    return Fail(outputType: Account?.self, failure: error).eraseToAnyPublisher()
                case .cancelled:
                    return Just(Account?.none)
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                    return GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name"])
                        .start(type: Account.self)
                }
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

extension LoginManager {
    func logIn(permissions: [FBSDKCoreKit.Permission]) -> AnyPublisher<FBSDKLoginKit.LoginResult, Error> {
        return Deferred {
            Future<FBSDKLoginKit.LoginResult, Error> { promise in
                self.logIn(viewController: nil, configuration: nil,completion: { result in
                        promise(.success(result))
                })
                           
                
            }
        }
        .eraseToAnyPublisher()
    }
}

extension GraphRequest {
    func start() -> AnyPublisher<Any?, Error> {
        return Deferred {
            Future<Any?, Error> { promise in
                self.start { _, result, error in
                    if let error = error {
                        promise(.failure(error))
                    } else {
                        promise(.success(result))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func start<T>(type: T.Type, decoder: JSONDecoder = JSONDecoder()) -> AnyPublisher<T?, Error> where T: Decodable {
        start()
            .tryMap({ result -> T? in
                guard let result = result else { return nil }
                let object = try decoder.decode(T.self, from: JSONSerialization.data(withJSONObject: result))
                return object
            })
            .eraseToAnyPublisher()
    }
}

struct Account: Codable, Equatable {
    let id: String
    let name: String
    let firstName: String
    
    enum CodingKeys: String, CodingKey {
      case id
      case name
      case firstName = "first_name"
    }
}
