//
//  MushroomSpecies.swift
//  ShroomHub
//
//  Created by Catalin Lucaciu on 24.04.2025.
//

import FirebaseFirestore

struct MushroomSpecies: Decodable, Hashable {
    @DocumentID var id: String?
    let scientificName: String
    let commonNames: [String]
    let season: String
    let lookalikes: [String]
    let notes: String
    let images: [String]
    let taxonomy: Taxonomy
    let morphology: MushroomSpecies.Morphology
    let edibility: Edibility
    let habitat: Habitat
}

extension MushroomSpecies {
    struct Taxonomy: Decodable, Hashable {
        let kingdom: String
        let phylum: String
        let taxonomyClass: String
        let order: String
        let family: String
        let genus: String
        
        private enum CodingKeys: String, CodingKey {
            case kingdom
            case phylum
            case taxonomyClass = "class"
            case order
            case family
            case genus
        }
    }
}

extension MushroomSpecies {
    struct Morphology: Decodable, Hashable {
        let cap: String?
        let gills: String?
        let stem: String?
        let flesh: String?
    }
}

extension MushroomSpecies {
    struct Edibility: Decodable, Hashable {
        let isEdible: Bool
        let isPsychoactive: Bool
        let toxicity: String
    }
}

extension MushroomSpecies {
    struct Habitat: Decodable, Hashable {
        let distribution: String
        let environment: String
    }
}
