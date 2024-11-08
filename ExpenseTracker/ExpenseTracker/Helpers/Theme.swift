//
//  Theme.swift
//  ExpenseTracker
//
//  Created by Swapnil on 29/10/24.
//

import Foundation
import SwiftUI

struct Theme {
    var backgroundColor: Color
    var primaryColor: Color
    var secondaryColor: Color
}

extension Theme {
    static let orangeTheme = Theme(
        backgroundColor: Color.orange.opacity(0.2),
        primaryColor: Color.orange,
        secondaryColor: Color.blue
    )
}
