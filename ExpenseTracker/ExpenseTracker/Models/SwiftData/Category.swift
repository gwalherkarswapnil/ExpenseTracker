//
//  Category.swift
//  Expense
//
//  Created by Swapnil on 28/10/24.
//
import Foundation
import SwiftData

@Model
final class Category {
    var name: String
    
    @Relationship(deleteRule: .cascade, inverse: \Expense.category)
    var expenses: [Expense]?
    
    init(name: String) {
        self.name = name
    }
}
