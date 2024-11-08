//
//  TrackingRecurringExpence.swift
//  ExpenseTracker
//
//  Created by Swapnil Gwalherkar on 28/10/24.
//

import SwiftUI

import SwiftUI
import Foundation
import SwiftData

@Model
final class RecurringExpense {
    var amount: Double
  //  var frequency: Frequency
    var note: String
    var startDate: Date
    var endDate: Date?

    init(amount: Double, frequency: Frequency, note: String, startDate: Date, endDate: Date?) {
        self.amount = amount
       // self.frequency = frequency
        self.note = note
        self.startDate = startDate
        self.endDate = endDate
    }
}

enum Frequency: String, CaseIterable {
    case daily, weekly, monthly, quaterly, yearly
}
struct RecurringExpensesView: View {
    @Environment(\.modelContext) var modelContext
    @State private var isFormPresented: Bool = false
    @State private var recurringExpenses: [RecurringExpense] = []
    
    @State private var amount: String = ""
    @State private var frequency: Frequency = .monthly
    @State private var note: String = ""
    @State private var startDate: Date = Date()
    @State private var endDate: Date?

    var body: some View {
        NavigationStack {
            List {
                ForEach($recurringExpenses, id: \.self) { expense in
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Amount: \(100, specifier: "%.2f")")
                           // Text("Frequency: \(expense.frequency.rawValue.capitalized)")
                            Text("Note: \(expense.note)")
                        }
                        Spacer()
                        Button("Delete") {
                           // delete(expense: expense)
                        }
                        .buttonStyle(.bordered)
                    }
                }
            }
            .navigationTitle("Recurring Expenses")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isFormPresented.toggle()
                    }) {
                        Text("Add")
                    }
                }
            }
            .sheet(isPresented: $isFormPresented) {
                Form {
                    Section(header: Text("Recurring Expense Details")) {
                        TextField("Amount", text: $amount)
                            .keyboardType(.decimalPad)
                        Picker("Frequency", selection: $frequency) {
                            ForEach(Frequency.allCases, id: \.self) { freq in
                                Text(freq.rawValue.capitalized).tag(freq)
                            }
                        }
                        TextField("Note", text: $note)
                        DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                        //DatePicker("End Date", selection: Binding($endDate, replacingNilWith: Date())! , displayedComponents: .date)
                    }
                    Button("Save") {
                        saveRecurringExpense()
                    }
                }
                .padding()
            }
        }
        .onAppear {
            fetchRecurringExpenses()
        }
    }

    private func saveRecurringExpense() {
        guard let amountValue = Double(amount) else { return }
        
        let recurringExpense = RecurringExpense(amount: amountValue, frequency: frequency, note: note, startDate: startDate, endDate: endDate)
        modelContext.insert(recurringExpense)
        
        // Clear the form
        amount = ""
        frequency = .monthly
        note = ""
        startDate = Date()
        endDate = nil
        
        fetchRecurringExpenses() // Refresh the list
    }

    private func fetchRecurringExpenses() {
        // Fetch recurring expenses from the model context and assign to recurringExpenses
        // This part should include your fetching logic.
    }

    private func delete(expense: RecurringExpense) {
        modelContext.delete(expense)
        fetchRecurringExpenses() // Refresh the list
    }
}

#Preview {
    RecurringExpensesView()
}
