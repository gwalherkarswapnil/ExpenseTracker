//
//  FontModifier.swift
//  ExpenseTracker
//
//  Created by Swapnil on 08/11/24.
//

import SwiftUI

struct FontModifier: ViewModifier {
    var size: CGFloat
    var weight: Font.Weight = .regular

    private var fontWeightString: String {
        switch weight {
        case .bold:
            return "Montserrat-Bold"
        case .light:
            return "Montserrat-Light"
        case .semibold:
            return "Montserrat-SemiBold"
        default:
            return "Montserrat-Regular"
        }
    }

    func body(content: Content) -> some View {
        content
            .font(.custom(fontWeightString, size: size))
    }
}


extension View {
    func appFont(size: CGFloat, weight: Font.Weight = .regular) -> some View {
        self.modifier(FontModifier(size: size, weight: weight))
    }
}
