////
////  File.swift
////  ExpenseTracker
////
////  Created by Swapnil on 01/12/24.
////
//
//import Foundation
//import CoreData
//
//struct PersistenceController {
//    static let shared = PersistenceController()
//
//    @MainActor
//    static let preview: PersistenceController = {
//        let result = PersistenceController(inMemory: true)
//        let viewContext = result.container.viewContext
//        
//        // Sample data for preview
//        let category = Category.createCategory(name: "Food", context: viewContext)
//        let expense = Expense.createExpense(amount: 50.0, note: "Lunch", date: Date(), category: category, context: viewContext)
//        
//        // Save sample data
//        do {
//            try viewContext.save()
//        } catch {
//            let nsError = error as NSError
//            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//        }
//        
//        return result
//    }()
//
//    let container: NSPersistentContainer
//
//    init(inMemory: Bool = false) {
//        container = NSPersistentContainer(name: "CoreDataExpenseTracker")
//        if inMemory {
//            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
//        }
//        
//        container.loadPersistentStores { (storeDescription, error) in
//            if let error = error as NSError? {
//                fatalError("Unresolved error \(error), \(error.userInfo)")
//            }
//        }
//        
//        container.viewContext.automaticallyMergesChangesFromParent = true
//    }
//    
//    // Add function to save context
//    func saveContext() {
//        let context = container.viewContext
//        if context.hasChanges {
//            do {
//                try context.save()
//            } catch {
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
//    }
//    
//    // Fetch function for expenses
//    func fetchExpenses() -> [Expense]? {
//        let context = container.viewContext
//        let fetchRequest: NSFetchRequest<Expense> = Expense.fetchRequest()
//        do {
//            return try context.fetch(fetchRequest)
//        } catch {
//            print("Failed to fetch expenses: \(error)")
//            return nil
//        }
//    }
//    
//    // Fetch function for categories
//    func fetchCategories() -> [Category]? {
//        let context = container.viewContext
//        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
//        do {
//            return try context.fetch(fetchRequest)
//        } catch {
//            print("Failed to fetch categories: \(error)")
//            return nil
//        }
//    }
//}
