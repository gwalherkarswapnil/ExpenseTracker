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
    var theme: Theme = Theme.homeOrangeTheme
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
                .onAppear {
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
                    .multilineTextAlignment(.center)
                
                Text("Rs. 17.000.000")
                    .font(.largeTitle)
                    .foregroundColor(.gray)
                    .padding(5)
                
                Button(action: {
                    isEntryFormPresented.toggle()
                }) {
                    Label("Record Expense", systemImage: "square.and.pencil")
                        .foregroundColor(.black)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(LinearGradient(colors: [theme.primaryColor, theme.secondaryColor], startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(15)
                        .shadow(radius: 10)
                }
                .sheet(isPresented: $isEntryFormPresented, onDismiss: calculateTotalExpenses) {
                    EntryExpenseView(isPresented: $isEntryFormPresented)
                }
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
    
    // Top Spending Section
    private var topSpendingSection: some View {
        Section {
            ForEach(0...10, id: \.self) { category in
                NavigationLink(destination: ExpenseListView()) {
                    VStack(alignment: .leading, spacing: 5) {
                        HStack {
                            Text("\(category)")
                                .font(.headline)
                                .foregroundColor(.gray)
                            
                            Spacer()
                            Text("Rs. 200.000")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))
                        }
                        ProgressView(value: 1)
                            .tint(theme.secondaryColor)
                    }
                    .padding()
                    .background(theme.primaryColor.opacity(0.8))
                    .cornerRadius(15)
                    .shadow(radius: 5)
                }
                .swipeActions(edge: .leading, allowsFullSwipe: false) {
                    Button {
                        isEditCategoryInputPresented.toggle()
                    } label: {
                        Text("Edit")
                    }
                    .tint(theme.primaryColor)
                }
            }
            .onDelete(perform: delete)
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
    
    private func calculateTotalExpenses() {
        // Calculate the total expenses based on your data model
    }
    
    private func delete(at offsets: IndexSet) {
        // Handle delete logic here
    }
    
    private func saveCategory() {
//        print("perform save")
//        let category = Category(name: categoryName)
//        modelContext.insert(category)
//        categoryName = ""
//        print("saved!")
    }
    
    private func saveEditCategory() {
        print("perform edit")
    }
}

#Preview {
    HomeContentView()
}
