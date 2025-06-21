//
//  Expense.swift
//  Expense
//
//  Created by Swapnil Gwalherkar on 28/10/24.
//

import Foundation
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
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Expense> {
        return NSFetchRequest<Expense>(entityName: "Expense")
    }
    
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



