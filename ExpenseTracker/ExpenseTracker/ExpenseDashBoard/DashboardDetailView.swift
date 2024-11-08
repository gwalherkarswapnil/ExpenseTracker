//
//  DashboardDetailView.swift
//  ExpenseTracker
//
//  Created by Swapnil Gwalherkar on 29/10/24.
//

import SwiftUI

import SwiftUI

struct DashboardDetailView: View {
    // Assuming we have a list of all expenses
    @State var expenses: [Expense]
    
    var totalExpenses: Double {
        expenses.reduce(0) { $0 + $1.amount }
    }
    
    var expensesByCategory: [String: Double] {
        Dictionary(grouping: expenses, by: { $0.category?.name ?? "Uncategorized" })
            .mapValues { $0.reduce(0) { $0 + $1.amount } }
    }
    
    var recentExpenses: [Expense] {
        return expenses.sorted(by: { $0.date > $1.date })//.prefix(5)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Dashboard")
                .font(.largeTitle)
                .padding(.bottom, 20)
            
            // Total Expenses
            Text("Total Expenses: Rp \(totalExpenses, specifier: "%.0f")")
                .font(.title2)
                .padding(.bottom, 20)
            
            // Expenses by Category
            Text("Expenses by Category")
                .font(.headline)
                .padding(.bottom, 10)
            
            ForEach(expensesByCategory.keys.sorted(), id: \.self) { category in
                HStack {
                    Text(category)
                        .font(.subheadline)
                    Spacer()
                    Text("Rp \(expensesByCategory[category]!, specifier: "%.0f")")
                        .font(.subheadline)
                }
                .padding(.vertical, 5)
            }
            
            Divider().padding(.vertical, 10)
            
            // Recent Expenses
            Text("Recent Expenses")
                .font(.headline)
                .padding(.bottom, 10)
            
            ForEach(recentExpenses, id: \.self) { expense in
                HStack {
                    VStack(alignment: .leading) {
                        Text("Rp \(expense.amount, specifier: "%.0f")")
                            .font(.subheadline)
                        Text(expense.note)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Text(expense.date, style: .date)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 5)
            }
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    DashboardDetailView(expenses: [
        Expense(amount: 50000, note: "Coffee with friends", date: Date()),
        Expense(amount: 100000, note: "Groceries", date: Date().addingTimeInterval(-86400)),
        Expense(amount: 20000, note: "Snacks", date: Date().addingTimeInterval(-172800))
    ])
}
