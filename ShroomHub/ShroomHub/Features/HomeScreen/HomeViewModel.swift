//
//  HomeViewModel.swift
//  ShroomHub
//
//  Created by Catalin Lucaciu on 22.05.2025.
//

import Foundation
import FirebaseAuthPackage

@Observable
final class HomeViewModel {
    let mushroomService: MushroomServiceProtocol
    let appSession: any AppSessionProtocol
    
    init(
        mushroomService: MushroomServiceProtocol,
        appSession: any AppSessionProtocol
    ) {
        self.mushroomService = mushroomService
        self.appSession = appSession
    }
    
    func getFeed() async throws -> [HomeFeedPost] {
        try await mushroomService.getFeed(except: "musat")
    }
}
