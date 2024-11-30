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

import CoreData

@objc(Expense)
public class Expense: NSManagedObject {
    @NSManaged public var amount: Double
    @NSManaged public var note: String
    @NSManaged public var date: Date
    @NSManaged public var createdAt: Date
    @NSManaged public var photo: Data?
    @NSManaged public var category: Category?
    @NSManaged public var recurringExpenseID: String?
    
    // Helper initializer to create an Expense object from your model
    static func createExpense(amount: Double, note: String, date: Date, category: Category? = nil, context: NSManagedObjectContext) -> Expense {
        let expense = Expense(context: context)
        expense.amount = amount
        expense.note = note
        expense.date = date
        expense.createdAt = Date()
        expense.category = category
        return expense
    }
}

@objc(Category)
public class Category: NSManagedObject {
    @NSManaged public var name: String
    @NSManaged public var expenses: Set<Expense>?
    @NSManaged public var id: String?
    
    // Helper initializer to create a Category object from your model
    static func createCategory(name: String, context: NSManagedObjectContext) -> Category {
        let category = Category(context: context)
        category.name = name
        return category
    }
}


