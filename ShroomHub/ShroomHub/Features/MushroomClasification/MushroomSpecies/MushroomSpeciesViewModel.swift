//
//  MushroomSpeciesViewModel.swift
//  ShroomHub
//
//  Created by Catalin Lucaciu on 27.04.2025.
//

import Foundation
import Observation
import CSRLocationService
import FirebaseAuthPackage
import FirebaseFirestore

private enum Constants {
    static let speciesCollectionName = "mushrooms"
}

@Observable
final class MushroomSpeciesViewModel {
    let service: MushroomServiceProtocol
    let locationService: LocationProviding
    let classificationResult: MushroomClassificationResult
    let appSession: any AppSessionProtocol
    
    init(classificationResult: MushroomClassificationResult,
         service: MushroomServiceProtocol,
         locationService: LocationProviding,
         appSession: any AppSessionProtocol) {
        self.classificationResult = classificationResult
        self.service = service
        self.locationService = locationService
        self.appSession = appSession
    }
    
    func fetchSpecies() async throws -> MushroomSpecies {
        let species = try await service.fetchSpecies(classificationName: classificationResult.speciesName)
        return species
    }
}

// MARK: - Post
extension MushroomSpeciesViewModel {
    func createMushroomPost(for species: MushroomSpecies, message: String) async throws {
        let finding = try await createFinding(for: species)
        try await service.postMushroom(
            finding,
            message: message
        )
    }
}

// MARK: - Save
extension MushroomSpeciesViewModel {
    func saveMushroom(for species: MushroomSpecies) async throws {
        let finding = try await createFinding(for: species)
        try await service.saveToCollection(finding)
    }
}

// MARK: - Utils
extension MushroomSpeciesViewModel {
    func createFinding(for species: MushroomSpecies) async throws -> MushroomFinding {
        let location = try await locationService.getCurrentLocation()
        guard let user = appSession.currentUser else {
            throw MushroomError.photoUploadingError
        }
        guard let imageData = classificationResult.image.jpegData(compressionQuality: 0.8) else {
            throw MushroomError.photoUploadingError
        }
        
        
        let url = try await service.uploadMushroomPhoto(with: imageData, userID: user.id)
        let mushroomFinding = MushroomFinding(
            id: classificationResult.id,
            userId: user.id,
            speciesReference: Firestore.firestore()
                .collection(Constants.speciesCollectionName)
                .document(classificationResult.speciesName),
            timestamp: Int(Date().timeIntervalSince1970),
            location: GeoPoint(latitude: location.coordinate.latitude,
                               longitude: location.coordinate.longitude), altitude: location.altitude,
            imageUrl: url.absoluteString
        )
        return mushroomFinding
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
        var morphologyItems: [EnumerationSectionItem] = []
        if let cap = morphology.cap {
            let capItem = EnumerationSectionItem(key: capKey, value: cap)
            morphologyItems.append(capItem)
        }
        if let gills = morphology.gills {
            let gillsItem = EnumerationSectionItem(key: gillsKey, value: gills)
            morphologyItems.append(gillsItem)
        }
        if let stem = morphology.stem {
            let stemItem = EnumerationSectionItem(key: stemKey, value: stem)
            morphologyItems.append(stemItem)
        }
        if let flesh = morphology.flesh {
            let fleshItem = EnumerationSectionItem(key: fleshKey, value: flesh)
            morphologyItems.append(fleshItem)
        }
        return morphologyItems
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
