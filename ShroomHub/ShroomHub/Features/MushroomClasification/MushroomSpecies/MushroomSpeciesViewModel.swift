//
//  MushroomSpeciesViewModel.swift
//  ShroomHub
//
//  Created by Catalin Lucaciu on 27.04.2025.
//

import Foundation
import Observation

@Observable
final class MushroomSpeciesViewModel {
    let service: MushroomServiceProtocol
    let classificationName: String
    
    init(classificationName: String,
        service: MushroomServiceProtocol) {
        self.classificationName = classificationName
        self.service = service
    }
    
    func fetchSpecies() async throws -> MushroomSpecies {
        let species = try await service.fetchSpecies(classificationName: classificationName)
        return species
    }
    
    func mapTaxonomyItems(from taxonomy: MushroomSpecies.Taxonomy) -> [EnumerationSectionItem] {
        [
            EnumerationSectionItem(key: kingdomKey, value: taxonomy.kingdom),
            EnumerationSectionItem(key: phylumKey, value: taxonomy.phylum),
            EnumerationSectionItem(key: classKey, value: taxonomy.taxonomyClass),
            EnumerationSectionItem(key: orderKey, value: taxonomy.order),
            EnumerationSectionItem(key: familyKey, value: taxonomy.family),
            EnumerationSectionItem(key: genusKey, value: taxonomy.genus)
        ]
    }
    
    func mapMorphologyItems(from morphology: MushroomSpecies.Morphology) -> [EnumerationSectionItem] {
        [
            EnumerationSectionItem(key: capKey, value: morphology.cap),
            EnumerationSectionItem(key: gillsKey, value: morphology.gills),
            EnumerationSectionItem(key: stemKey, value: morphology.stem),
            EnumerationSectionItem(key: fleshKey, value: morphology.flesh)
        ]
    }
    
    func createMushroomPost(for species: MushroomSpecies) {
        print("to do")
    }
    
    func saveMushroom(for species: MushroomSpecies) {
        print("to do")
    }
}

// MARK: - Taxonomy Keys
private extension MushroomSpeciesViewModel {
    var kingdomKey: String {
        "Kingdom"
    }

    var phylumKey: String {
        "Phylum"
    }

    var classKey: String {
        "Class"
    }

    var orderKey: String {
        "Order"
    }

    var familyKey: String {
        "Family"
    }

    var genusKey: String {
        "Genus"
    }
}

// MARK: - Morphology Keys
private extension MushroomSpeciesViewModel {
    var capKey: String {
        "Cap"
    }

    var gillsKey: String {
        "Gills"
    }

    var stemKey: String {
        "Stem"
    }

    var fleshKey: String {
        "Flesh"
    }
}
