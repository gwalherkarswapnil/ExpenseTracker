//
//  ContentView.swift
//  SwiftData ExpenseTracker
//
//  Created by Swapnil Gwalherkar on 28/10/24.
//

import SwiftUI
import Charts
import SwiftData
import CoreData

enum ClearOption: String, CaseIterable {
    case allExpenses = "All Expenses"
    case allCategories = "All Categories"
    case everything = "Everything"
    
    var description: String {
        switch self {
        case .allExpenses:
            return "Delete all expenses but keep categories"
        case .allCategories:
            return "Delete all categories (will also delete their expenses)"
        case .everything:
            return "Delete all expenses and categories"
        }
    }
}

struct HomeContentView: View {
    var theme: Theme = Theme.homeOrangeTheme
    @Environment(\.managedObjectContext) var managedObjectContext
    @State var isEntryFormPresented: Bool = false
    @State var isCategoryInputPresented: Bool = false
    @State var isEditCategoryInputPresented: Bool = false
    
    @State var categoryName: String = ""
    @State var totalExpenses: Double = 0
    @State private var expenses: [Expense] = []
    @State private var categories: [Category] = []
    @State private var expensesData: [(category: String, amount: Double)] = []
    @State private var showingClearAlert = false
    @State private var clearOption: ClearOption = .allExpenses
    
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
                .scrollContentBackground(.hidden) // Prevents default background
                
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
                .sheet(isPresented: $isEntryFormPresented) {
                    EntryExpenseView(isPresented: $isEntryFormPresented) {
                        loadData()
                    }
                }
                .onAppear {
                    loadData()
                }
                .alert("Clear Records", isPresented: $showingClearAlert) {
                    Button("Cancel", role: .cancel) { }
                    Button("Clear All Expenses", role: .destructive) {
                        clearOption = .allExpenses
                        performClear()
                    }
                    Button("Clear All Categories", role: .destructive) {
                        clearOption = .allCategories
                        performClear()
                    }
                    Button("Clear Everything", role: .destructive) {
                        clearOption = .everything
                        performClear()
                    }
                } message: {
                    Text("Choose what you want to clear. This action cannot be undone.")
                }
            }
        }
    }
    
    // Total Spending Section
    private var totalSpendingSection: some View {
        Section {
            Group {
            VStack(spacing: 15) {
                Text("Total Spending")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                
                if expenses.isEmpty {
                    VStack(spacing: 10) {
                        Image(systemName: "chart.bar.doc.horizontal")
                            .font(.system(size: 50))
                            .foregroundColor(.gray.opacity(0.5))
                        
                        Text("No expenses recorded")
                            .font(.title3)
                            .foregroundColor(.gray)
                        
                        Text("Start tracking your expenses by adding your first expense")
                            .font(.caption)
                            .foregroundColor(.gray.opacity(0.7))
                            .multilineTextAlignment(.center)
                    }
                    .padding(.vertical, 20)
                } else {
                    Text("₹\(totalExpenses, specifier: "%.2f")")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                        .padding(5)
                }
                
                VStack(spacing: 15) {
                    // Record Expense Button
                    Button(action: {
                        print("Record Expense button tapped")
                        isEntryFormPresented.toggle()
                    }) {
                        Label("Record Expense", systemImage: "square.and.pencil")
                            .foregroundColor(.black)
                            .padding()
                            .frame(maxWidth: .infinity, minHeight: 44)
                            .background(LinearGradient(colors: [theme.primaryColor, theme.secondaryColor], startPoint: .leading, endPoint: .trailing))
                            .cornerRadius(15)
                            .shadow(radius: 10)
                    }

                    // Clear Records Button
                    if !expenses.isEmpty {
                        Button(action: {
                            print("Clear Records button tapped")
                            showingClearAlert = true
                        }) {
                            Label("Clear Records", systemImage: "trash")
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity, minHeight: 44)
                                .background(Color.red)
                                .cornerRadius(15)
                                .shadow(radius: 5)
                        }
                    }
                }

            }
            .padding(.vertical)
            .background(.opacity(0.8))
            .cornerRadius(15)
            .shadow(radius: 5)
            }
            .listRowInsets(EdgeInsets())
        }
    }
    
    // Expense Chart Section
    private var expenseChartSection: some View {
        Section(header: Text("Expense Overview").foregroundColor(.gray)) {
            if expensesData.isEmpty {
                VStack(spacing: 15) {
                    Image(systemName: "chart.bar")
                        .font(.system(size: 40))
                        .foregroundColor(.gray.opacity(0.5))
                    
                    Text("No data to display")
                        .font(.headline)
                        .foregroundColor(.gray)
                    
                    Text("Add some expenses to see your spending overview")
                        .font(.caption)
                        .foregroundColor(.gray.opacity(0.7))
                        .multilineTextAlignment(.center)
                }
                .frame(height: 200)
                .frame(maxWidth: .infinity)
                .background(Color.white.opacity(0.1))
                .cornerRadius(15)
                .shadow(radius: 5)
            } else {
                Chart {
                    ForEach(expensesData, id: \.category) { data in
                        BarMark(
                            x: .value("Category", data.category),
                            y: .value("Amount", data.amount)
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
    }
    
    // Top Spending Section
    private var topSpendingSection: some View {
        Section {
            if categories.isEmpty {
                VStack(spacing: 15) {
                    Image(systemName: "folder")
                        .font(.system(size: 40))
                        .foregroundColor(.gray.opacity(0.5))
                    
                    Text("No categories created")
                        .font(.headline)
                        .foregroundColor(.gray)
                    
                    Text("Create categories to organize your expenses")
                        .font(.caption)
                        .foregroundColor(.gray.opacity(0.7))
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 30)
            } else {
                ForEach(categories, id: \.self) { category in
                    NavigationLink(destination: ExpenseListView(category: category)) {
                        VStack(alignment: .leading, spacing: 5) {
                            HStack {
                                Text(category.name)
                                    .font(.headline)
                                    .foregroundColor(.gray)
                                
                                Spacer()
                                Text("₹\(categoryTotal(for: category), specifier: "%.2f")")
                                    .font(.subheadline)
                                    .foregroundColor(.white.opacity(0.8))
                            }
                            ProgressView(value: categoryProgress(for: category))
                                .tint(theme.secondaryColor)
                        }
                        .padding()
                        .background(theme.primaryColor.opacity(0.8))
                        .cornerRadius(15)
                        .shadow(radius: 5)
                    }
                    .swipeActions(edge: .leading, allowsFullSwipe: false) {
                        Button {
                            categoryName = category.name
                            isEditCategoryInputPresented.toggle()
                        } label: {
                            Text("Edit")
                        }
                        .tint(theme.primaryColor)
                    }
                }
                .onDelete(perform: delete)
            }
        } header: {
            HStack {
                Text("Top Spending")
                    .font(.headline)
                    .foregroundColor(.gray)
                Spacer()
                Button(action: {
                    categoryName = ""
                    isCategoryInputPresented.toggle()
                }) {
                    Label("New category", systemImage: "plus")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
            }
        }
    }
    
    // MARK: - Helper Functions
    
    private func loadData() {
        expenses = PersistenceController.shared.fetchExpenses() ?? []
        categories = PersistenceController.shared.fetchCategories() ?? []
        calculateTotalExpenses()
        calculateExpensesData()
    }
    
    private func calculateTotalExpenses() {
        totalExpenses = expenses.reduce(0) { $0 + $1.amount }
    }
    
    private func calculateExpensesData() {
        var categoryTotals: [String: Double] = [:]
        
        for expense in expenses {
            let categoryName = expense.category?.name ?? "Uncategorized"
            categoryTotals[categoryName, default: 0] += expense.amount
        }
        
        expensesData = categoryTotals.map { (category: $0.key, amount: $0.value) }
            .sorted { $0.amount > $1.amount }
    }
    
    private func categoryTotal(for category: Category) -> Double {
        return Array(category.expenses ?? []).reduce(0) { $0 + $1.amount }
    }
    
    private func categoryProgress(for category: Category) -> Double {
        let categoryAmount = categoryTotal(for: category)
        return totalExpenses > 0 ? categoryAmount / totalExpenses : 0
    }
    
    private func delete(at offsets: IndexSet) {
        for index in offsets {
            let category = categories[index]
            PersistenceController.shared.container.viewContext.delete(category)
        }
        PersistenceController.shared.saveContext()
        loadData()
    }
    
    private func saveCategory() {
        guard !categoryName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let context = PersistenceController.shared.container.viewContext
        let _ = Category.createCategory(name: categoryName, context: context)
        PersistenceController.shared.saveContext()
        
        categoryName = ""
        loadData()
    }
    
    private func saveEditCategory() {
        guard !categoryName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        // Find and update the existing category
        if let existingCategory = categories.first(where: { $0.name == categoryName }) {
            existingCategory.name = categoryName
            PersistenceController.shared.saveContext()
            loadData()
        }
    }
    
    private func performClear() {
        switch clearOption {
        case .allExpenses:
            PersistenceController.shared.clearAllExpenses()
        case .allCategories:
            PersistenceController.shared.clearAllCategories()
        case .everything:
            PersistenceController.shared.clearAllData()
        }
        
        loadData()
    }
}

#Preview {
    HomeContentView()
}
