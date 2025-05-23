//
//  MushroomSpeciesViewModel.swift
//  ShroomHub
//
//  Created by Catalin Lucaciu on 13.05.2025.
//

import Foundation
import Observation
import SHUtils
import CSRNetworkService
import FirebaseAuthPackage
import FirebaseFirestore

@Observable
final class MushroomCollectionViewModel {
    let service: MushroomServiceProtocol
    let appSession: any AppSessionProtocol
    
    init(service: MushroomServiceProtocol,
         appSession: any AppSessionProtocol) {
        self.service = service
        self.appSession = appSession
    }
    
    func getSavedMushrooms() async throws -> [CollectedMushroom] {
        let userId = appSession.currentUser?.id ?? ""
        return try await service.getMushroomCollection(for: userId)
    }

}
