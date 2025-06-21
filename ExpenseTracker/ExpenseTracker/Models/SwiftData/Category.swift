//
//  Category.swift
//  Expense
//
//  Created by Swapnil Gwalherkar on 28/10/24.
//
import Foundation
import SwiftData
import CoreData

@objc(Category)
public class Category: NSManagedObject {
    @NSManaged public var name: String
    @NSManaged public var expenses: Set<Expense>?
    @NSManaged public var id: String?
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category")
    }
    
    // Helper initializer to create a Category object from your model
    static func createCategory(name: String, context: NSManagedObjectContext) -> Category {
        let category = Category(context: context)
        category.name = name
        return category
    }
}
