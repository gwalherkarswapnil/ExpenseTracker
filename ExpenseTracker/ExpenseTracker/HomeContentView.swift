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
    @State private var animateCards = false
    @State private var selectedCategoryIndex: Int? = nil
    
    var body: some View {
        NavigationStack {
            ZStack {
                theme.backgroundColor
                    .ignoresSafeArea()
                
                ScrollView {
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
                
                VStack(spacing: 10) {
                    // Record Expense Button
                    Button(action: {
                        print("Record Expense button tapped")
                        isEntryFormPresented = true
                    }) {
                        Label("Record Expense", systemImage: "square.and.pencil")
                            .font(.subheadline)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .frame(maxWidth: .infinity, minHeight: 36)
                            .background(LinearGradient(colors: [theme.primaryColor, theme.secondaryColor], startPoint: .leading, endPoint: .trailing))
                            .foregroundColor(.black)
                            .cornerRadius(12)
                            .shadow(radius: 4)
                    }

                    // Clear Records Button
                    if !expenses.isEmpty {
                        Button(action: {
                            print("Clear Records button tapped")
                            showingClearAlert = true
                        }) {
                            Label("Clear Records", systemImage: "trash")
                                .font(.subheadline)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 10)
                                .frame(maxWidth: .infinity, minHeight: 36)
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                                .shadow(radius: 3)
                        }
                    }
                }
            }
            .padding()
            .background(Color(.systemBackground).opacity(0.95))
            .cornerRadius(15)
            .shadow(radius: 5)
        }
        .listRowBackground(Color.clear)
        .listRowSeparator(.hidden)
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
    
    // Top Spending Section - Beautiful Animated Design
    private var topSpendingSection: some View {
        VStack(spacing: 0) {
            // Header with gradient background
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Top Spending")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("\(categories.count) categories")
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.8))
                }
                
                Spacer()
                
                Button(action: {
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                        categoryName = ""
                        isCategoryInputPresented.toggle()
                    }
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title3)
                        .foregroundColor(.white)
                        .background(Circle().fill(Color.white.opacity(0.2)))
                        .scaleEffect(selectedCategoryIndex == nil ? 1.0 : 0.9)
                }
                .buttonStyle(PlainButtonStyle())
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                LinearGradient(
                    colors: [theme.primaryColor, theme.secondaryColor],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .shadow(color: theme.primaryColor.opacity(0.3), radius: 6, x: 0, y: 3)
            
            // Content Area
            if categories.isEmpty {
                emptyStateView
            } else {
                categoriesGridView
            }
        }
        .padding(.horizontal, 12)
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8)) {
                animateCards = true
            }
        }
    }
    
    // Empty State View
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            // Animated Folder Icon
            Image(systemName: "folder.badge.plus")
                .font(.system(size: 40, weight: .light))
                .foregroundStyle(
                    LinearGradient(
                        colors: [theme.primaryColor, theme.secondaryColor],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .scaleEffect(animateCards ? 1.0 : 0.5)
                .opacity(animateCards ? 1.0 : 0.3)
                .animation(.easeInOut(duration: 1.0), value: animateCards)
            
            VStack(spacing: 8) {
                Text("Create Your First Category")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Text("Organize your expenses by creating categories like Food, Transport, Entertainment")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            
            // CTA Button
            Button(action: {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                    categoryName = ""
                    isCategoryInputPresented.toggle()
                }
            }) {
                HStack(spacing: 6) {
                    Image(systemName: "plus.circle.fill")
                        .font(.caption)
                    Text("Create Category")
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(
                    LinearGradient(
                        colors: [theme.primaryColor, theme.secondaryColor],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .clipShape(Capsule())
                .shadow(color: theme.primaryColor.opacity(0.3), radius: 4, x: 0, y: 2)
            }
            .scaleEffect(animateCards ? 1.0 : 0.8)
            .animation(.spring(response: 0.8, dampingFraction: 0.6).delay(0.3), value: animateCards)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 24)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 1)
    }
    
    // Categories Grid View
    private var categoriesGridView: some View {
        LazyVStack(spacing: 8) {
            ForEach(Array(categories.enumerated()), id: \.element) { index, category in
                CategoryCardView(
                    category: category,
                    index: index,
                    isSelected: selectedCategoryIndex == index,
                    theme: theme,
                    categoryTotal: categoryTotal(for: category),
                    categoryProgress: categoryProgress(for: category),
                    onTap: {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                            selectedCategoryIndex = selectedCategoryIndex == index ? nil : index
                        }
                    },
                    onEdit: {
                        categoryName = category.name
                        isEditCategoryInputPresented.toggle()
                    }
                )
                .scaleEffect(animateCards ? 1.0 : 0.3)
                .opacity(animateCards ? 1.0 : 0.0)
                .animation(
                    .spring(response: 0.8, dampingFraction: 0.8)
                    .delay(Double(index) * 0.1),
                    value: animateCards
                )
            }
        }
        .padding(.horizontal, 4)
        .padding(.top, 12)
    }
    
    // MARK: - Helper Functions
    
    private func loadData() {
        // Reset animations
        animateCards = false
        selectedCategoryIndex = nil
        
        expenses = PersistenceController.shared.fetchExpenses() ?? []
        categories = PersistenceController.shared.fetchCategories() ?? []
        calculateTotalExpenses()
        calculateExpensesData()
        
        // Trigger animations after data load
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.easeInOut(duration: 0.8)) {
                animateCards = true
            }
        }
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

// MARK: - Category Card View Component
struct CategoryCardView: View {
    let category: Category
    let index: Int
    let isSelected: Bool
    let theme: Theme
    let categoryTotal: Double
    let categoryProgress: Double
    let onTap: () -> Void
    let onEdit: () -> Void
    
    @State private var isPressed = false
    
    // Dynamic colors based on category index
    private var cardGradient: [Color] {
        let gradients = [
            [Color.blue, Color.purple],
            [Color.green, Color.teal],
            [Color.orange, Color.red],
            [Color.purple, Color.pink],
            [Color.teal, Color.blue],
            [Color.indigo, Color.purple]
        ]
        return gradients[index % gradients.count]
    }
    
    var body: some View {
        NavigationLink(destination: ExpenseListView(category: category)) {
            VStack(alignment: .leading, spacing: 12) {
                // Header Row
                HStack {
                    // Category Icon & Name
                    HStack(spacing: 10) {
                        // Dynamic Icon
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: cardGradient,
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 32, height: 32)
                                .shadow(color: cardGradient[0].opacity(0.3), radius: 3, x: 0, y: 1)
                            
                            Image(systemName: categoryIcon(for: category.name))
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white)
                        }
                        
                        VStack(alignment: .leading, spacing: 1) {
                            Text(category.name)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                            
                            Text("\(category.expenses?.count ?? 0) expenses")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Spacer()
                    
                    // Amount & Edit Button
                    VStack(alignment: .trailing, spacing: 2) {
                        Text("₹\(categoryTotal, specifier: "%.0f")")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        Button(action: onEdit) {
                            Image(systemName: "pencil.circle.fill")
                                .font(.subheadline)
                                .foregroundColor(cardGradient[0])
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                
                // Progress Section
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text("Share of total spending")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Text("\(categoryProgress * 100, specifier: "%.1f")%")
                            .font(.caption2)
                            .fontWeight(.medium)
                            .foregroundColor(cardGradient[0])
                    }
                    
                    // Custom Progress Bar
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            // Background
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.gray.opacity(0.2))
                                .frame(height: 6)
                            
                            // Progress Fill
                            RoundedRectangle(cornerRadius: 4)
                                .fill(
                                    LinearGradient(
                                        colors: cardGradient,
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(width: geometry.size.width * categoryProgress, height: 6)
                                .animation(.easeInOut(duration: 1.0).delay(Double(index) * 0.1), value: categoryProgress)
                        }
                    }
                    .frame(height: 6)
                }
                
                // Additional Details (shown when selected)
                if isSelected {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Last expense")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                            
                            if let lastExpense = category.expenses?.max(by: { $0.date < $1.date }) {
                                Text(lastExpense.date, style: .date)
                                    .font(.caption)
                                    .fontWeight(.medium)
                                    .foregroundColor(.primary)
                            } else {
                                Text("No expenses")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 4) {
                            Text("Avg per expense")
                                .font(.caption2)
                                .foregroundColor(.secondary)
                            
                            let expenseCount = category.expenses?.count ?? 0
                            let avgAmount = expenseCount > 0 ? categoryTotal / Double(expenseCount) : 0
                            
                            Text("₹\(avgAmount, specifier: "%.0f")")
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(.primary)
                        }
                    }
                    .padding(.top, 8)
                    .transition(.asymmetric(
                        insertion: .opacity.combined(with: .move(edge: .top)),
                        removal: .opacity
                    ))
                }
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color(.systemBackground))
                    .shadow(
                        color: isSelected ? cardGradient[0].opacity(0.3) : .black.opacity(0.06),
                        radius: isSelected ? 8 : 4,
                        x: 0,
                        y: isSelected ? 4 : 2
                    )
            )
            .scaleEffect(isPressed ? 0.98 : 1.0)
            .scaleEffect(isSelected ? 1.02 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
            .animation(.easeInOut(duration: 0.15), value: isPressed)
        }
        .buttonStyle(PlainButtonStyle())
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    withAnimation(.easeInOut(duration: 0.1)) {
                        isPressed = true
                    }
                }
                .onEnded { _ in
                    withAnimation(.easeInOut(duration: 0.1)) {
                        isPressed = false
                    }
                    onTap()
                }
        )
    }
    
    // Helper function to get category-specific icons
    private func categoryIcon(for categoryName: String) -> String {
        switch categoryName.lowercased() {
        case let name where name.contains("food") || name.contains("dining"):
            return "fork.knife"
        case let name where name.contains("transport") || name.contains("travel"):
            return "car.fill"
        case let name where name.contains("shop") || name.contains("retail"):
            return "bag.fill"
        case let name where name.contains("entertainment") || name.contains("fun"):
            return "tv.fill"
        case let name where name.contains("health") || name.contains("medical"):
            return "heart.fill"
        case let name where name.contains("bill") || name.contains("utilit"):
            return "bolt.fill"
        case let name where name.contains("home") || name.contains("house"):
            return "house.fill"
        case let name where name.contains("education") || name.contains("learn"):
            return "book.fill"
        default:
            return "tag.fill"
        }
    }
}

#Preview {
    HomeContentView()
}
