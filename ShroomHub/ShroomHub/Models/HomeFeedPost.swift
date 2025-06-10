//
//  HomeFeedPost.swift
//  ShroomHub
//
//  Created by Catalin Lucaciu on 22.05.2025.
//

import Foundation

struct HomeFeedPost: Identifiable {
    let id: UUID = UUID()
    let collectedMushroom: CollectedMushroom
    let postDetails: MushroomFeedPost
    let userDetails: FireBaseUser
}

