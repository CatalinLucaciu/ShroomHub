//
//  MushroomMapViewModel.swift
//  ShroomHub
//
//  Created by Catalin Lucaciu on 07.06.2025.
//

import Foundation
import CSRLocationService
import CoreLocation

@Observable
final class MushroomMapViewModel {
    private let service: MushroomServiceProtocol
    private let locationService: LocationProviding
    var currentLocation: CLLocationCoordinate2D = .init(latitude: 0, longitude: 0)
    
    init(service: MushroomServiceProtocol,
         locationService: LocationProviding) {
        self.service = service
        self.locationService = locationService
    }
    
    func getCollectedMushrooms() async throws -> [CollectedMushroom] {
        currentLocation = try await locationService.getCurrentLocation().coordinate
        return try await service.getAllCollectedMushrooms()
    }
}
