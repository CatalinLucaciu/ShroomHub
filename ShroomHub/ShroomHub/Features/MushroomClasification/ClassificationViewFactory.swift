//
//  ClassificationViewFactory.swift
//  ShroomHub
//
//  Created by Catalin Lucaciu on 27.04.2025.
//

import SwiftUI
import CSRLocationService
import FirebaseAuthPackage
import CSRNetworkService

struct ClassificationViewFactory {
    let appSession: any AppSessionProtocol
    
    var mushroomService: MushroomSpeciesService {
        MushroomSpeciesService(
            networkService: NetworkService(),
            locationProvder: locationService
        )
    }
    
    var locationService: CSRLocationService {
        CSRLocationService()
    }
    
    @ViewBuilder
    func makeView(for destination: ClassificationTabDestination) -> some View {
        switch destination {
        case .classification:
            Text("placeholder")
        case let .speciesDetails(classificationResult):
            speciesDetails(for: classificationResult)
        }
    }
}

// MARK: - Views
private extension ClassificationViewFactory {
    @ViewBuilder
    func speciesDetails(for classificationResult: MushroomClassificationResult) -> some View {
        let viewModel = MushroomSpeciesViewModel(
            classificationResult: classificationResult,
            service: mushroomService,
            locationService: locationService,
            appSession: appSession
        )
        MushroomSpeciesView(viewModel: viewModel)
    }
}
