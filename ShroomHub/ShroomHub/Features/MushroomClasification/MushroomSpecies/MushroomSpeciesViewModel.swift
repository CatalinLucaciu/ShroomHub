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
}

