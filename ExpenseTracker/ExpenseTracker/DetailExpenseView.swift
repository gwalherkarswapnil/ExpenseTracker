//
//  DetailExpenseView.swift
//  ExpenseTracker
//
//  Created by Swapnil Gwalherkar on 28/10/24.
//
import SwiftUI
import CoreData

struct DetailExpenseView: View {
    let expense: Expense
    
    @State private var isEditMode = false
    @State private var editAmount: Double = 0
    @State private var editNote: String = ""
    @State private var editDate: Date = Date()
    @State private var editCategory: Category?
    @State private var categories: [Category] = []
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Form {
            Section(header: Text("Expense Details")) {
                if isEditMode {
                    editFormContent
                } else {
                   // viewOnlyContent
                }
            }
            
            if let photoData = expense.photo, let uiImage = UIImage(data: photoData) {
                Section(header: Text("Receipt Photo")) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .clipShape(RoundedRectangle(cornerRadius: 10.0))
                        .padding(.vertical, 10)
                }
            }
        }
//        .navigationTitle(expense.date, style: .date)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                if isEditMode {
                    Button("Save") {
                        saveChanges()
                    }
                } else {
                    Button("Edit") {
                        startEditing()
                    }
                }
            }
            
            if isEditMode {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        cancelEditing()
                    }
                }
            }
        }
        .onAppear {
            loadCategories()
        }
    }
    
//    private var viewOnlyContent: some View {
//        Group {
//            DetailRow(label: "Category", value: expense.category?.name ?? "No Category")
//            DetailRow(label: "Amount", value: "₹\(expense.amount, specifier: "%.2f")")
//            DetailRow(label: "Notes", value: expense.note.isEmpty ? "No notes" : expense.note)
//            DetailRow(label: "Date", value: expense.date.formatted(date: .complete, time: .omitted))
//        }
//    }
    
    private var editFormContent: some View {
        Group {
            Picker("Category", selection: $editCategory) {
                Text("No Category").tag(nil as Category?)
                ForEach(categories, id: \.self) { category in
                    Text(category.name).tag(category as Category?)
                }
            }
            .pickerStyle(.navigationLink)
            
            HStack {
                Text("Amount")
                Spacer()
                TextField("Amount", value: $editAmount, format: .currency(code: "INR"))
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.trailing)
            }
            
            HStack {
                Text("Notes")
                Spacer()
                TextField("Notes", text: $editNote)
                    .multilineTextAlignment(.trailing)
            }
            
            DatePicker("Date", selection: $editDate, displayedComponents: .date)
        }
    }
    
    private func startEditing() {
        editAmount = expense.amount
        editNote = expense.note
        editDate = expense.date
        editCategory = expense.category
        isEditMode = true
    }
    
    private func cancelEditing() {
        isEditMode = false
    }
    
    private func saveChanges() {
        PersistenceController.shared.updateExpense(
            expense,
            amount: editAmount,
            note: editNote,
            date: editDate,
            category: editCategory
        )
        isEditMode = false
    }
    
    private func loadCategories() {
        categories = PersistenceController.shared.fetchCategories() ?? []
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
        DetailExpenseView(expense: Expense())
    }
}
