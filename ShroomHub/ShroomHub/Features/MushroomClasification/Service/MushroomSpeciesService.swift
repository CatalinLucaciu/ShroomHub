//
//  MushroomSpeciesService.swift
//  ShroomHub
//
//  Created by Catalin Lucaciu on 24.04.2025.
//

import FirebaseFirestore
import Firebase
import Foundation

private enum Constants {
    static let collectionName = "mushrooms"
}

protocol MushroomServiceProtocol {
    /// Fetches a single MushroomSpecies document by its classification name (document ID).
    /// - Parameter classificationName: The Document ID of the species to fetch.
    /// - Returns: The decoded MushroomSpecies object.
    /// - Throws: `FirestoreError` if fetching or decoding fails.
    func fetchSpecies(classificationName: String) async throws -> MushroomSpecies
}

final class MushroomSpeciesService: MushroomServiceProtocol {
    private let db = Firestore.firestore()
    
    func fetchSpecies(classificationName: String) async throws -> MushroomSpecies {
        let documentReference = db.collection(Constants.collectionName).document(classificationName)
        return try await documentReference.getDocument(as: MushroomSpecies.self)
    }
}
