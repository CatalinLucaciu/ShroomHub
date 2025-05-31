//
//  HomeFeedPost.swift
//  ShroomHub
//
//  Created by Catalin Lucaciu on 22.05.2025.
//

import Foundation

struct HomeFeedPost: Identifiable {
    let id: UUID = UUID()
    let finding: MushroomFinding
    let postDetails: MushroomFeedPost
    let speciesDetails: MushroomSpecies
    let userDetails: FireBaseUser
    let location: String?
    let locationURL: URL?
}

