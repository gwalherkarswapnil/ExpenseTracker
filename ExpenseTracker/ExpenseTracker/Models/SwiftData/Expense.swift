//
//  CategoryInputView.swift
//  Expense
//
//  Created by Swapnil Gwalherkar on 28/10/24.
//

import Foundation

import Foundation
import SwiftData

import SwiftData

@Model
final class Expense {
    var amount: Double
    var note: String
    var date: Date
    var createdAt: Date
    
    @Attribute(.externalStorage)
    var photo: Data?
    
    // Optional relationship to a Category
    var category: Category?
    
    init(amount: Double, note: String, date: Date, category: Category? = nil) {
        self.amount = amount
        self.note = note
        self.date = date
        self.createdAt = Date()
        self.category = category
    }
}

