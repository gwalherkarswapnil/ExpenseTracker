//
//  SnapShotScanView.swift
//  ExpenseTracker
//
//  Created by Swapnil on 11/11/24.
//

import SwiftUI
import SwiftUI
import Vision

struct SnapshotScanView: View {
    let image: UIImage
    @State private var totalAmount: String?
    @State private var productDetails: [String] = []
    @State private var isProcessing = true

    var body: some View {
        VStack(spacing: 20) {
            if isProcessing {
                ProgressView("Processing Image...")
                    .progressViewStyle(CircularProgressViewStyle())
            } else {
                // Display extracted total amount and product details
                if let totalAmount = totalAmount {
                    Text("Total Amount: \(totalAmount)")
                        .font(.title)
                        .fontWeight(.bold)
                }
                
                if !productDetails.isEmpty {
                    Text("Product Details:")
                        .font(.headline)
                        .padding(.top)
                    
                    ForEach(productDetails, id: \.self) { detail in
                        Text(detail)
                            .font(.body)
                    }
                }
            }
        }
        .padding()
        .onAppear {
            processImage()
        }
    }

    // Method to process the image and extract data using OCR
    private func processImage() {
        extractExpenseData(from: image) { amount, details in
            DispatchQueue.main.async {
                self.totalAmount = amount
                self.productDetails = details
                self.isProcessing = false
            }
        }
    }
    
    // OCR extraction function
    private func extractExpenseData(from image: UIImage, completion: @escaping (String?, [String]) -> Void) {
        guard let cgImage = image.cgImage else {
            completion(nil, [])
            return
        }

        // Create a text recognition request
        let request = VNRecognizeTextRequest { (request, error) in
            guard let observations = request.results as? [VNRecognizedTextObservation], error == nil else {
                completion(nil, [])
                return
            }

            var totalAmount: String?
            var productDetails: [String] = []

            // Process each text observation
            for observation in observations {
                guard let recognizedText = observation.topCandidates(1).first?.string else { continue }
                let lowerText = recognizedText.lowercased()

                // Look for patterns indicating the total expense
                if totalAmount == nil, lowerText.contains("total") || lowerText.contains("amount") {
                    let amountPattern = "\\$?\\d+\\.\\d{2}"  // Adjust the pattern as needed for your data
                    if let match = recognizedText.range(of: amountPattern, options: .regularExpression) {
                        totalAmount = String(recognizedText[match])
                    }
                } else {
                    // Otherwise, assume it's a product detail line
                    productDetails.append(recognizedText)
                }
            }

            completion(totalAmount, productDetails)
        }

        // Configure request properties
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true

        // Perform the request on a background thread
        DispatchQueue.global(qos: .userInitiated).async {
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            do {
                try handler.perform([request])
            } catch {
                print("Failed to perform text recognition request: \(error)")
                completion(nil, [])
            }
        }
    }
}

// Preview or Usage Example
#Preview {
    if let sampleImage = UIImage(named: "sample_receipt") {
        SnapshotScanView(image: sampleImage)
    } else {
        Text("Sample image not found.")
    }
}




// Image picker helper view
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    var onImagePicked: () -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
                parent.onImagePicked()
            }
            picker.dismiss(animated: true)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}

