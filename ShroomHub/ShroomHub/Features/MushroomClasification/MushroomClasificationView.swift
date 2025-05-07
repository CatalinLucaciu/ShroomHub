//
//  MushroomClasificationView.swift
//  ShroomHub
//
//  Created by Catalin Lucaciu on 11.04.2025.
//

import CSRImageClassifier
import SwiftUI
import Vision
import ShroomHubDesignLibrary
import SHNavigation
import SHUtils

private enum Constants {
    static let errorImage = "species_not_found_ic"
}

struct MushroomClasificationView: View {
    @EnvironmentObject private var navigationRouter: NavigationRouter
    @State private var classificationState: LoadableState<ClassificationResult, ClassificationError> = .idle
    let model = createImageClassifier()
    let service = MushroomSpeciesService()
    var body: some View {
        content
            .onAppear {
                classificationState = .idle
            }
    }
}

// MARK: - Views
private extension MushroomClasificationView {
    @ViewBuilder
    var content: some View {
        switch classificationState {
        case .idle:
            imageClassifier
        case .loading:
            ProgressView()
        case let .failure(error):
            GeneralErrorView(
                imageName: Constants.errorImage,
                errorMessage: error.localizedDescription) {
                    classificationState = .idle
            }
        default:
            EmptyView()
        }
    }
    
    @ViewBuilder
    var imageClassifier: some View {
        CSRImageClassifierView(model: model) { result in
            classificationState = .loading
            DispatchQueue.main.async {
                // MARK: - TO DO: - Remove Mock
                let mockedClassification = ClassificationResult(label: "Pluteus_cervinus", confidence: 1)
                
                navigationRouter.navigate(to: ClassificationTabDestination.speciesDetails(mockedClassification.label),
                                          in: .classification)
//                switch result {
//                case let .success(classficationResult):
//                    if let result = classficationResult.first {
//                        classificationState = .loaded(result)
//                    }
//                case let .failure(error):
//                    classificationState = .failure(error)
//                }
            }
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
