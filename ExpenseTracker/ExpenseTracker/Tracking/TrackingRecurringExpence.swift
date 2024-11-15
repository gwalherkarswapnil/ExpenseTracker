//
//  TrackingRecurringExpence.swift
//  ExpenseTracker
//
//  Created by Swapnil Gwalherkar on 28/10/24.
//

import SwiftUI
import Foundation
import SwiftData

enum Frequency: String, CaseIterable {
    case daily, weekly, monthly, quarterly, yearly
}


struct RecurringExpensesView: View {
    var theme: Theme
    @Environment(\.modelContext) var modelContext
    @State private var isFormPresented: Bool = false
    @State private var recurringExpenses: [RecurringExpense] = []
    @State private var amount: String = ""
    @State private var frequency: Frequency = .monthly
    @State private var note: String = ""
    @State private var startDate: Date = Date()
    @State private var endDate: Date?
    @State private var validationMessage = ""

    var body: some View {
        NavigationStack {
            VStack {
                Image("recurring_icon")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .shadow(radius: 10)
                
                List {
                    ForEach($recurringExpenses, id: \.self) { expense in
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Amount: \(expense.amount.wrappedValue, specifier: "%.2f")")
                                Text("Note: \(expense.note.wrappedValue)")
                            }
                            Spacer()
                            Button("Delete") {
                                delete(expense: expense.wrappedValue)
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(theme.primaryColor)
                        }
                    }
                    .onDelete(perform: deleteExpense)
                }
                .navigationTitle("Recurring Expenses")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: { isFormPresented.toggle() }) {
                            Text("Add")
                        }
                    }
                }
                .sheet(isPresented: $isFormPresented) {
                    Form {
                        Section(header: Text("Recurring Expense Details")) {
                            TextField("Amount", text: $amount)
                                .keyboardType(.decimalPad)
                                .padding()
                                .background(theme.backgroundColor.opacity(0.1))
                                .cornerRadius(15)
                                .shadow(color: .gray.opacity(0.3), radius: 5)
                            
                            Picker("Frequency", selection: $frequency) {
                                ForEach(Frequency.allCases, id: \.self) {
                                    Text($0.rawValue.capitalized)
                                }
                            }
                            
                            TextField("Note", text: $note)
                                .padding()
                                .background(theme.backgroundColor.opacity(0.1))
                                .cornerRadius(15)
                            
                            DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                            //DatePicker("End Date", selection: Binding($endDate, replacingNilWith: Date()) ?? <#default value#>, displayedComponents: .date)
                        }
                        
                        if !validationMessage.isEmpty {
                            Text(validationMessage)
                                .foregroundColor(.red)
                                .font(.caption)
                        }
                        
                        Button("Save") {
                            validateAndSaveExpense()
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(LinearGradient(colors: [theme.primaryColor, theme.secondaryColor], startPoint: .leading, endPoint: .trailing))
                        .foregroundColor(.white)
                        .cornerRadius(15)
                        .shadow(radius: 10)
                    }
                    .padding()
                }
            }
            .onAppear {
                fetchRecurringExpenses()
            }
            .background(theme.backgroundColor.ignoresSafeArea())
        }
    }

    private func validateAndSaveExpense() {
        guard let amountValue = Double(amount), amountValue > 0 else {
            validationMessage = "Please enter a valid amount."
            return
        }
        
        let recurringExpense = RecurringExpense(amount: amountValue, frequency: frequency, note: note, startDate: startDate, endDate: endDate)
        modelContext.insert(recurringExpense)
        
        // Clear the form
        amount = ""
        frequency = .monthly
        note = ""
        startDate = Date()
        endDate = nil
        validationMessage = ""
        
        fetchRecurringExpenses() // Refresh the list
    }

    private func fetchRecurringExpenses() {
        // Fetch recurring expenses from the model context
        // Populate the recurringExpenses array with the data
    }

    private func delete(expense: RecurringExpense) {
        modelContext.delete(expense)
        fetchRecurringExpenses() // Refresh the list
    }

    private func deleteExpense(at offsets: IndexSet) {
        // Logic for deleting expense based on the list position
    }
}

#Preview {
    RecurringExpensesView(theme: Theme.orangeTheme)
}
