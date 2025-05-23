//
//  HomeFeedPost.swift
//  ShroomHub
//
//  Created by Catalin Lucaciu on 22.05.2025.
//

import Foundation

struct HomeFeedPost {
    let finding: MushroomFinding
    let postDetails: MushroomFeedPost
    let speciesDetails: MushroomSpecies
    let location: String?
    let locationURL: URL?
}
