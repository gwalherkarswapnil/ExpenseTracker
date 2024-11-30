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
    ]
    
    var body: some View {
        List {
            ForEach(expenses.indices, id: \.self) { index in
                NavigationLink {
                    DetailExpenseView()
                } label: {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Rs. \(expenses[index].amount, specifier: "%.0f")")
                                .appFont(size: 16)

                            
                            Text(expenses[index].note)
                                .appFont(size: 14)
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
