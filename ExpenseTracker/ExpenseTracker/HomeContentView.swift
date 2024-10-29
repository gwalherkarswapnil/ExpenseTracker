//
//  ContentView.swift
//  SwiftData ExpenseTracker
//
//  Created by Swapnil on 28/10/24.
//

import SwiftUI
import Charts


struct HomeContentView: View {
    @Environment(\.modelContext) var modelContext
    @State var isEntryFormPresented: Bool = false
    @State var isCategoryInputPresented: Bool = false
    @State var isEditCategoryInputPresented: Bool = false
    
    @State var categoryName: String = ""
    @State var totalExpenses: Double = 0
    
    // Sample Data for Chart
    let expensesData: [(category: String, amount: Double)] = [
        ("Food", 5000),
        ("Rent", 7000),
        ("Transportation", 3000),
        ("Entertainment", 2000),
        ("Utilities", 1500)
    ]
    
    var body: some View {
        NavigationStack {
            List {
                totalSpendingSection
                expenseChartSection
                topSpendingSection
            }
            .listStyle(.insetGrouped)
            .sheet(isPresented: $isCategoryInputPresented) {
                CategoryInputView(categoryName: $categoryName) {
                    saveCategory()
                }
            }
            .sheet(isPresented: $isEditCategoryInputPresented) {
                CategoryInputView(categoryName: $categoryName) {
                    saveEditCategory()
                }
            }
            .onAppear {
                calculateTotalExpenses()
            }
        }
    }
    
    // Total Spending Section
    private var totalSpendingSection: some View {
        Section {
            VStack {
                Text("Total Spending")
                    .font(.headline)
                    .multilineTextAlignment(.center)
                Text("Rp 17.000.000")
                    .font(.largeTitle)
                    .padding(5)
                
                Button(action: {
                    isEntryFormPresented.toggle()
                }) {
                    Label("Record Expense", systemImage: "square.and.pencil")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .sheet(isPresented: $isEntryFormPresented, onDismiss: calculateTotalExpenses) {
                    EntryExpenseView(isPresented: $isEntryFormPresented)
                }
            }
            .padding(.vertical)
        }
    }
    
    // New Expense Chart Section
    private var expenseChartSection: some View {
        Section(header: Text("Expense Overview")) {
            Chart {
                ForEach(expensesData, id: \.category) { data in
                    BarMark(
                        x: .value("Category", data.category),
                        y: .value("Amount", data.amount)
                    )
                    .foregroundStyle(.blue)
                }
            }
            .frame(height: 250) // Adjust height as needed
            .padding()
        }
    }
    
    // Top Spending Section (your existing code)
    private var topSpendingSection: some View {
        Section {
            ForEach(0...10, id: \.self) { category in
                NavigationLink(destination: ExpenseListView()) {
                    VStack {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("\(category)")
                                    .font(.headline)
                                Text("Rp 200.000")
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Text("100 %")
                                .font(.headline)
                        }
                        ProgressView(value: 1)
                    }
                }
                .swipeActions(edge: .leading, allowsFullSwipe: false) {
                    Button {
                        isEditCategoryInputPresented.toggle()
                    } label: {
                        Text("Edit")
                    }
                    .tint(.blue)
                }
            }
            .onDelete(perform: delete)
        } header: {
            HStack {
                Text("Top Spending")
                    .font(.headline)
                Spacer()
                Button(action: {
                    categoryName = ""
                    isCategoryInputPresented.toggle()
                }) {
                    Label("New category", systemImage: "plus")
                        .font(.subheadline)
                }
            }
        }
    }
    
    // MARK: - Helper Functions
    
    private func calculateTotalExpenses() {
        // Calculate the total expenses based on your data model
    }
    
    private func delete(at offsets: IndexSet) {
        // Handle delete logic here
    }
    
    private func saveCategory() {
        print("perform save")
        let category = Category(name: categoryName)
        modelContext.insert(category)
        categoryName = ""
        print("saved!")
    }
    
    private func saveEditCategory() {
        print("perform edit")
    }
}


#Preview {
    HomeContentView()
}
