//
//  MushroomFeedPost.swift
//  ShroomHub
//
//  Created by Catalin Lucaciu on 11.05.2025.
//

import FirebaseFirestore
import Foundation

struct MushroomFeedPost: Codable, Hashable {
    @DocumentID var id: String?
    let findingReference: DocumentReference
    let userId: String
    let message: String
    let likeCount: Int
    let commentCount: Int
    let timestamp: Int
}

extension MushroomFeedPost {
    var formatedDateString: String {
        Date(timeIntervalSince1970: TimeInterval(timestamp)).formattedAsRelativeOrAbsolute
    }
}
