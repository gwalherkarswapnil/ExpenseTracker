//
//  CategoryInputView.swift
//  ExpenseTracker
//
//  Created by Swapnil Gwalherkar on 28/10/24.
//

import SwiftUI

struct CategoryInputView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var categoryName: String
    var onSave: () -> Void
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Category Name")) {
                    TextField("Enter category name", text: $categoryName)
                }
            }
            .navigationTitle("Category")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    cancelButton
                }
                ToolbarItem(placement: .confirmationAction) {
                    saveButton
                }
            }
        }
    }
    
    private var cancelButton: some View {
        Button("Cancel") {
            dismiss()
        }
    }
    
    private var saveButton: some View {
        Button("Save") {
            onSave()
            dismiss()
        }
        .disabled(categoryName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
    }
}
