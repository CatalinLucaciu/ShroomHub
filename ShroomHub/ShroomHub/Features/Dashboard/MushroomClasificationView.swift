//
//  MushroomClasificationView.swift
//  ShroomHub
//
//  Created by Catalin Lucaciu on 11.04.2025.
//

import CSRImageClassifier
import SwiftUI
import Vision

struct MushroomClasificationView: View {
    @State private var clasificationResult: Result<[ClassificationResult], ClassificationError>?
    let model = createImageClassifier()
    var body: some View {
        VStack {
            CSRImageClassifierView(model: model) { result in
                DispatchQueue.main.async {
                    clasificationResult = result
                }
            }
            resultDisplayer
        }
        
    }
}

// MARK: - Views
private extension MushroomClasificationView {
    @ViewBuilder
    var resultDisplayer: some View {
        switch clasificationResult {
            case let .success(results):
                VStack {
                    ForEach(results, id: \.self) { result in
                        Text("\(result.label) \(result.confidence)%")
                    }
                }
            case let .failure(error):
                Text(error.errorDescription ?? "")
        case .none:
            Text("")
        }
    }
}


private extension MushroomClasificationView {
    static func createImageClassifier() -> VNCoreMLModel {
        // Use a default model configuration.
        let defaultConfig = MLModelConfiguration()


        // Create an instance of the image classifier's wrapper class.
        let imageClassifierWrapper = try? CSRImageClassifier(configuration: defaultConfig)


        guard let imageClassifier = imageClassifierWrapper else {
            fatalError("App failed to create an image classifier model instance.")
        }


        // Get the underlying model instance.
        let imageClassifierModel = imageClassifier.model


        // Create a Vision instance using the image classifier's model instance.
        guard let imageClassifierVisionModel = try? VNCoreMLModel(for: imageClassifierModel) else {
            fatalError("App failed to create a `VNCoreMLModel` instance.")
        }


        return imageClassifierVisionModel
    }
}
