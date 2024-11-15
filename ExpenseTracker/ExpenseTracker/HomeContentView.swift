//
//  ContentView.swift
//  SwiftData ExpenseTracker
//
//  Created by Swapnil Gwalherkar on 28/10/24.
//

import SwiftUI
import Charts
import SwiftData

struct HomeContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: \Expense.date, order: .reverse) var expenses: [Expense]
    @State private var isEntryFormPresented: Bool = false
    @State private var totalExpenses: Double = 0
    @State var categoryName: String?
    var theme: Theme = Theme.homeOrangeTheme
    
    var body: some View {
        NavigationStack {
            ZStack {
                theme.backgroundColor
                    .ignoresSafeArea()
                
                List {
                    totalSpendingSection
                    expenseChartSection
                    topSpendingSection
                }
                .listStyle(.insetGrouped)
                .scrollContentBackground(.hidden)
                .onAppear {
                    addSampleExpensesIfNeeded()
                    calculateTotalExpenses()
                }
            }
        }
    }
    
    // Total Spending Section
    private var totalSpendingSection: some View {
        Section {
            VStack {
                Text("Total Spending")
                    .font(.headline)
                    .foregroundColor(.gray)
                
                Text("Rs. \(totalExpenses, specifier: "%.2f")")
                    .font(.largeTitle)
                    .foregroundColor(.gray)
                    .padding(5)
            }
            .padding(.vertical)
            .background(.opacity(0.8))
            .cornerRadius(15)
            .shadow(radius: 5)
        }
    }
    
    // Expense Chart Section
    private var expenseChartSection: some View {
        Section(header: Text("Expense Overview").foregroundColor(.gray)) {
            Chart {
                ForEach(expenses, id: \.createdAt) { expense in
                    BarMark(
                        x: .value("Date", expense.date, unit: .day),
                        y: .value("Amount", expense.amount)
                    )
                    .foregroundStyle(.blue)
                }
            }
            .frame(height: 250)
            .padding()
            .background(Color.white.opacity(0.1))
            .cornerRadius(15)
            .shadow(radius: 5)
        }
    }
    
    // Top Spending Section
    private var topSpendingSection: some View {
        Section(header: Text("Top Spending Categories").foregroundColor(.gray)) {
            ForEach(expenses, id: \.createdAt) { expense in
                HStack {
                    Text(expense.note)
                        .font(.headline)
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Text("Rs. \(expense.amount, specifier: "%.2f")")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                }
                .padding()
                .background(theme.primaryColor.opacity(0.8))
                .cornerRadius(15)
                .shadow(radius: 5)
            }
        }
    }
    
    // MARK: - Helper Functions
    private func calculateTotalExpenses() {
        guard ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == nil else { return }

        totalExpenses = expenses.reduce(0) { $0 + $1.amount }
    }
    
    private func addSampleExpensesIfNeeded() {
    #if DEBUG
        if expenses.isEmpty {
            // Add mock data for preview
            guard ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == nil else { return }
            if expenses.isEmpty {
                let sampleExpenses = [
                    Expense(amount: 5000, note: "Food", date: Date()),
                    Expense(amount: 7000, note: "Rent", date: Date().addingTimeInterval(-86400)),
                    Expense(amount: 3000, note: "Transportation", date: Date().addingTimeInterval(-172800)),
                    Expense(amount: 2000, note: "Entertainment", date: Date().addingTimeInterval(-259200)),
                    Expense(amount: 1500, note: "Utilities", date: Date().addingTimeInterval(-345600))
                ]
                for expense in sampleExpenses {
                    modelContext.insert(expense)
                }
            }
        }
    #endif
        
    }


    // MARK: - Helper Functions
    
//    private func calculateTotalExpenses() {
//        // Calculate the total expenses based on your data model
//    }
    
    private func delete(at offsets: IndexSet) {
        // Handle delete logic here
    }
    
    private func saveCategory() {
        print("perform save")
        guard let categoryName = categoryName else { return }
        let category = Category(name: categoryName)
        modelContext.insert(category)
        self.categoryName = ""
        print("saved!")
    }
    
    private func saveEditCategory() {
        print("perform edit")
    }
}

#Preview {
    HomeContentView()
}
