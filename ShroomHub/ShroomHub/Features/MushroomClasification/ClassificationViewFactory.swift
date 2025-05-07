//
//  ClassificationViewFactory.swift
//  ShroomHub
//
//  Created by Catalin Lucaciu on 27.04.2025.
//

import SwiftUI

struct ClassificationViewFactory {
    var mushroomService: MushroomSpeciesService {
        MushroomSpeciesService()
    }
    
    @ViewBuilder
    func makeView(for destination: ClassificationTabDestination) -> some View {
        switch destination {
        case .classification:
            Text("placeholder")
        case let .speciesDetails(name):
            speciesDetails(for: name)
        }
    }
}

// MARK: - Views
private extension ClassificationViewFactory {
    @ViewBuilder
    func speciesDetails(for name: String) -> some View {
        let viewModel = MushroomSpeciesViewModel(classificationName: name, service: mushroomService)
        MushroomSpeciesView(viewModel: viewModel)
    }
}
