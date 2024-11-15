//
//  Category.swift
//  Expense
//
//  Created by Swapnil Gwalherkar on 28/10/24.
//
import Foundation
import SwiftData

@Model
final class Category {
    var name: String
    
   // @Relationship(deleteRule: .cascade, inverse: \Expense.category)
    var expenses: [Expense]?
    // Firestore document ID for this Category
       var id: String?
    init(name: String) {
        self.name = name
    }
    
    // Convert to Firestore-compatible format
       func toDictionary() -> [String: Any] {
           return [
               "name": name,
               "expenses": expenses?.map { $0.id } ?? [], // Store expense IDs
           ]
       }
}
