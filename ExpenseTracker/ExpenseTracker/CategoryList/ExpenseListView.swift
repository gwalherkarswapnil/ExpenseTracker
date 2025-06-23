//
//  ExpenseView.swift
//  SwiftData ExpenseTracker
//
//  Created by Swapnil Gwalherkar on 28/10/24.
//

import SwiftUI
import SwiftData
import CoreData

struct ExpenseListView: View {
    
    var category: Category?
    @State var title: String = "All Expenses"
    @State private var expenses: [Expense] = []
    @State private var showingAddExpense = false
    
    var body: some View {
        List {
            ForEach(expenses, id: \.self) { expense in
                NavigationLink {
                    DetailExpenseView(expense: expense) {
                        loadExpenses()
                    }
                } label: {
                    ExpenseRowView(expense: expense)
                }
            }
            .onDelete(perform: delete)
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: {
                    showingAddExpense = true
                }) {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddExpense) {
            EntryExpenseView(isPresented: $showingAddExpense) {
                loadExpenses()
            }
        }
        .onAppear {
            loadExpenses()
        }
    }
    
    func delete(at offsets: IndexSet) {
        for index in offsets {
            let expense = expenses[index]
            PersistenceController.shared.deleteExpense(expense)
        }
        loadExpenses()
    }
    
    private func loadExpenses() {
        if let category = category {
            expenses = Array(category.expenses ?? [])
                .sorted { $0.date > $1.date }
            title = category.name
        } else {
            expenses = PersistenceController.shared.fetchExpenses() ?? []
        }
    }
}

struct ExpenseRowView: View {
    let expense: Expense
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("₹\(expense.amount, specifier: "%.2f")")
                    .appFont(size: 16)
                    .fontWeight(.medium)
                
                Text(expense.note.isEmpty ? "No description" : expense.note)
                    .appFont(size: 14)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                
                if let category = expense.category {
                    Text(category.name)
                        .appFont(size: 12)
                        .foregroundStyle(.blue)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Color.blue.opacity(0.1))
                        .clipShape(Capsule())
                }
            }
            
            Spacer()
            
            VStack(alignment: .trailing) {
                Text(expense.date, style: .date)
                    .appFont(size: 12)
                    .foregroundStyle(.secondary)
                
                if expense.photo != nil {
                    Image(systemName: "photo")
                        .foregroundStyle(.gray)
                        .font(.caption)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    NavigationStack {
        ExpenseListView()
    }
}
