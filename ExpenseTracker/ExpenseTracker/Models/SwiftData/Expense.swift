//
//  CategoryInputView.swift
//  Expense
//
//  Created by Swapnil on 28/10/24.
//

import Foundation

import Foundation
import SwiftData

@Model
final class Expense {
    var amount: Double
    var note: String
    var date: Date
    var createdAt: Date
    
    @Attribute(.externalStorage)
    var photo: Data?
    
    var category: Category?
    
    init(amount: Double, note: String, date: Date) {
        self.amount = amount
        self.note = note
        self.date = date
        self.createdAt = Date.now
    }
}
