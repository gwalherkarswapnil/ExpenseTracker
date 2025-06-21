//
//
//  EntryExpenseView.swift
//  ExpenseTracker
//
//  Created by Swapnil Gwalherkar on 28/10/24.
//
import SwiftUI
import PhotosUI
import VisionKit
import CoreData

struct EntryExpenseView: View {
    @Binding var isPresented: Bool
    @State private var categories: [Category] = []
    @State private var selectedCategory: Category?
    @State private var amount: Double = 0
    @State private var notes: String = ""
    @State private var date: Date = Date.now
    
    @State private var selectedPhotos: [PhotosPickerItem] = []
    @State private var selectedImageData: Data?
    
    // For preview
    @State private var images: [UIImage] = []
    @State private var selectedImage: UIImage?
    @State private var isCameraPresented = false
    @State private var isSnapshotScanPresented = false  // New state variable for SnapshotScanView

    var body: some View {
        NavigationStack {
            Form {
                categoryPickerSection
                amountSection
                notesSection
                datePickerSection
                photoPickerSection
                imagesSection
            }
            .navigationTitle("Entry Expenses")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        save()
                        isPresented = false
                    }
                    .disabled(amount <= 0)
                }
                
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        isPresented = false
                    }
                }
            }
            .onAppear {
                loadCategories()
            }
            .onChange(of: selectedImage) { newImage in
                if newImage != nil {
                    isSnapshotScanPresented = true
                }
            }
            .sheet(isPresented: $isSnapshotScanPresented) {
                if let selectedImage = selectedImage {
                    SnapshotScanView(image: selectedImage)
                }
            }
        }
    }
    
    private var categoryPickerSection: some View {
        Section {
            Picker("Category", selection: $selectedCategory) {
                Text("Choose category").tag(nil as Category?)
                ForEach(categories, id: \.self) { category in
                    Text(category.name).tag(category as Category?)
                }
            }
            .pickerStyle(.navigationLink)
        }
    }
    
    private var amountSection: some View {
        Section {
            HStack {
                Text("Amount")
                Spacer()
                TextField("Amount:", value: $amount, format: .currency(code: "INR"))
                    .keyboardType(.numberPad)
            }
        }
    }
    
    private var notesSection: some View {
        Section {
            HStack {
                Text("Notes")
                Spacer()
                TextField("Expense note", text: $notes)
            }
        }
    }
    
    private var datePickerSection: some View {
        Section {
            DatePicker("Expenses Date", selection: $date, displayedComponents: .date)
        }
    }
    
    private var photoPickerSection: some View {
        Section {
            PhotosPicker(selection: $selectedPhotos, maxSelectionCount: 1, matching: .images) {
                Label("Select a photo", systemImage: "photo")
            }
            .onChange(of: selectedPhotos) {
                convertToImages()
            }
            
            // Button for opening the camera
            Button(action: {
                isCameraPresented = true
            }) {
                Label("Take a photo", systemImage: "camera")
            }
            .sheet(isPresented: $isCameraPresented) {
                CameraView(selectedImage: $selectedImage)
            }
            
            // Display the selected image
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }
        }
    }
    
    private var imagesSection: some View {
        Section {
            ForEach(images, id: \.self) { image in
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 10.0))
                    .padding(.vertical, 10)
            }
        }
    }
    
    private func save() {
        guard amount > 0 else { return }
        
        let _ = PersistenceController.shared.createExpense(
            amount: amount,
            note: notes,
            date: date,
            category: selectedCategory,
            photo: selectedImageData
        )
        
        // Reset form after saving
        resetForm()
    }
    
    private func resetForm() {
        amount = 0
        notes = ""
        date = Date.now
        selectedCategory = nil
        selectedPhotos = []
        selectedImageData = nil
        images = []
        selectedImage = nil
    }
    
    private func loadCategories() {
        categories = PersistenceController.shared.fetchCategories() ?? []
        
        // Create default categories if none exist
        if categories.isEmpty {
            createDefaultCategories()
        }
    }
    
    private func createDefaultCategories() {
        let defaultCategories = ["Food & Dining", "Transportation", "Shopping", "Entertainment", "Bills & Utilities", "Healthcare", "Travel", "Other"]
        
        for categoryName in defaultCategories {
            let context = PersistenceController.shared.container.viewContext
            let _ = Category.createCategory(name: categoryName, context: context)
        }
        
        PersistenceController.shared.saveContext()
        categories = PersistenceController.shared.fetchCategories() ?? []
    }
    
    private func convertToImages() {
        images.removeAll()
        
        for eachPhotoItem in selectedPhotos {
            Task {
                if let imageData = try? await eachPhotoItem.loadTransferable(type: Data.self) {
                    selectedImageData = imageData
                    if let image = UIImage(data: imageData) {
                        images.append(image)
                        selectedImage = image  // Set selectedImage when a new image is chosen
                    }
                }
            }
        }
    }
}



#Preview {
    EntryExpenseView(isPresented: .constant(true))
}
