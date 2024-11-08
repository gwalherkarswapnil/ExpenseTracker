//
//  ExpenseView.swift
//  SwiftData ExpenseTracker
//
//  Created by Swapnil Gwalherkar on 28/10/24.
//

import SwiftUI
import SwiftData
struct ExpenseListView: View {
    
    var category: Category?
    @State var title: String = "Food & Beverage"
    
    // Dummy data for expenses
    @State private var expenses: [Expense] = [
        Expense(amount: 50000, note: "Coffee with friends", date: Date()),
        Expense(amount: 100000, note: "Groceries", date: Date().addingTimeInterval(-86400)),
        Expense(amount: 20000, note: "Snacks", date: Date().addingTimeInterval(-172800)),
        Expense(amount: 20000, note: "Coke", date: Date().addingTimeInterval(-172500)),
        Expense(amount: 20000, note: "Sandwiches", date: Date().addingTimeInterval(-172100)),
        Expense(amount: 20000, note: "Tea", date: Date().addingTimeInterval(-172850)),
        Expense(amount: 20000, note: "Snacks", date: Date().addingTimeInterval(-17280))
        
    ]
    
    var body: some View {
        List {
            ForEach(expenses.indices, id: \.self) { index in
                NavigationLink {
                    DetailExpenseView()
                } label: {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Rp \(expenses[index].amount, specifier: "%.0f")")
                                .font(.headline)
                            
                            Text(expenses[index].note)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Text(expenses[index].date, style: .date)
                    }
                }
            }
            .onDelete(perform: delete)
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.large)
    }
    
    func delete(at offsets: IndexSet) {
        expenses.remove(atOffsets: offsets)
    }
}

#Preview {
    NavigationStack {
        ExpenseListView()
    }
}
