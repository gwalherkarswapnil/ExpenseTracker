//
//  UserValidator.swift
//  ExpenseTracker
//
//  Created by Swapnil on 04/11/24.
//

import Foundation
import Observation
@Observable class UserValidator {
    // Validation function for mobile number
     func isValidMobileNumber(_ mobileNumber: String) -> Bool {
         // Check if the mobile number contains exactly 10 digits
         let mobileNumberRegex = "^[0-9]{10}$"
         let predicate = NSPredicate(format: "SELF MATCHES %@", mobileNumberRegex)
         return predicate.evaluate(with: mobileNumber)
     }
    
    // Method to validate an email address
       func isValidEmail(_ email: String) -> Bool {
           let emailRegex = "^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}$"
           let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
           return predicate.evaluate(with: email)
       }
    
}
