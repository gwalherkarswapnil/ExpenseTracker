//
//  PersistenceController.swift
//  ExpenseTracker
//
//  Created by Swapnil on 01/12/24.
//

import Foundation
import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    @MainActor
    static let preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        // Sample data for preview
        let category = Category.createCategory(name: "Food", context: viewContext)
        let expense = Expense.createExpense(amount: 50.0, note: "Lunch", date: Date(), category: category, context: viewContext)
        
        // Save sample data
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "CoreDataExpenseTracker")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    // Add function to save context
    func saveContext() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    // Fetch function for expenses
    func fetchExpenses() -> [Expense]? {
        let context = container.viewContext
        let fetchRequest: NSFetchRequest<Expense> = Expense.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Expense.date, ascending: false)]
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch expenses: \(error)")
            return nil
        }
    }
    
    // Fetch function for categories
    func fetchCategories() -> [Category]? {
        let context = container.viewContext
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Category.name, ascending: true)]
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch categories: \(error)")
            return nil
        }
    }
    
    // Delete expense
    func deleteExpense(_ expense: Expense) {
        let context = container.viewContext
        context.delete(expense)
        saveContext()
    }
    
    // Update expense
    func updateExpense(_ expense: Expense, amount: Double, note: String, date: Date, category: Category?) {
        expense.amount = amount
        expense.note = note
        expense.date = date
        expense.category = category
        saveContext()
    }
    
    // Create new expense
    func createExpense(amount: Double, note: String, date: Date, category: Category?, photo: Data? = nil) -> Expense {
        let context = container.viewContext
        let expense = Expense.createExpense(amount: amount, note: note, date: date, category: category, context: context)
        expense.photo = photo
        saveContext()
        return expense
    }
    
    // Clear all data functions
    func clearAllExpenses() {
        let context = container.viewContext
        let fetchRequest: NSFetchRequest<Expense> = Expense.fetchRequest()
        
        do {
            let expenses = try context.fetch(fetchRequest)
            for expense in expenses {
                context.delete(expense)
            }
            saveContext()
        } catch {
            print("Failed to clear all expenses: \(error)")
        }
    }
    
    func clearAllCategories() {
        let context = container.viewContext
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        
        do {
            let categories = try context.fetch(fetchRequest)
            for category in categories {
                context.delete(category)
            }
            saveContext()
        } catch {
            print("Failed to clear all categories: \(error)")
        }
    }
    
    func clearAllData() {
        clearAllExpenses()
        clearAllCategories()
    }
}
