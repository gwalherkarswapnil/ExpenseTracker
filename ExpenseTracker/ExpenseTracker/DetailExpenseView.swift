//
//  NewSwiftUIView.swift
//  ExpenseTracker
//
//  Created by Swapnil on 28/10/24.
//
import SwiftUI
struct DetailExpenseView: View {
    
    var expense: Expense?
    
    var body: some View {
        Form {
            Section(header: Text("Expense Details")) {
                DetailRow(label: "Category", value: "Category Placeholder")
                DetailRow(label: "Amount", value: "Rp 50.000")
                DetailRow(label: "Notes", value: "Note placeholder")
            }
            
            Section(header: Text("Receipt Photo")) {
                Image("sample-photo")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 10.0))
                    .padding(.vertical, 10)
            }
        }
        .navigationTitle("Tue, 5 May")
        .navigationBarTitleDisplayMode(.large)
    }
}

struct DetailRow: View {
    var label: String
    var value: String
    
    var body: some View {
        HStack {
            Text(label)
            Spacer()
            Text(value)
                .foregroundColor(.secondary)
        }
    }
}



#Preview {
    NavigationStack {
        DetailExpenseView(expense: Expense(amount: 100,
                                           note: "notes",
                                           date: Date.now))
    }
}
