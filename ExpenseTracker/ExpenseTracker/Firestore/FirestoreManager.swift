//
//  FirestoreManager.swift
//  ExpenseTracker
//
//  Created by Swapnil on 13/11/24.
//

import Foundation
import FirebaseFirestore

final class FirestoreManager {
    private let db = Firestore.firestore()
    
    // MARK: - Save Category
    func saveCategory(_ category: Category, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let id  = category.id else { return }
        db.collection("categories").document(id).setData([
            "name": category.name
        ]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    // MARK: - Save Expense
    func saveExpense(_ expense: Expense, completion: @escaping (Result<Void, Error>) -> Void) {
#warning("Check Code for id")
        db.collection("expenses").document("").setData([
            "amount": expense.amount,
            "note": expense.note,
            "date": Timestamp(date: expense.date),
            "createdAt": Timestamp(date: expense.createdAt),
            "categoryID": expense.category?.id ?? "",
            "recurringExpenseID": expense.recurringExpenseID
        ]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    // MARK: - Save Recurring Expense
    func saveRecurringExpense(_ recurringExpense: RecurringExpense, completion: @escaping (Result<Void, Error>) -> Void) {
#warning("Check Code for id")

        db.collection("recurringExpenses").document("").setData([
            "amount": recurringExpense.amount,
            "note": recurringExpense.note,
            "startDate": Timestamp(date: recurringExpense.startDate),
            "endDate": recurringExpense.endDate != nil ? Timestamp(date: recurringExpense.endDate!) : NSNull(),
            "categoryID": recurringExpense.id
        ]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}
