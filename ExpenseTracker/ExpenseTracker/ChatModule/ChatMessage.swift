//
//  ChatMessage.swift
//  ExpenseTracker
//
//  Created by Swapnil on 01/12/24.
//

import Foundation
import SwiftUI

struct ChatMessage: Identifiable {
    let id = UUID()
    let text: String
    let isSentByUser: Bool
    let hasGraphic: Bool
    let graphic: GraphicType?
}

enum GraphicType {
    case barChart([CGFloat])
    case pieChart([CGFloat])
    case image(UIImage)
}
