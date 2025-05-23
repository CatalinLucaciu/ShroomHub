//
//  Untitled.swift
//  ShroomHub
//
//  Created by Catalin Lucaciu on 11.05.2025.
//

import FirebaseFirestore
import Foundation

struct MushroomSavedPost: Codable, Hashable {
    @DocumentID var id: String?
    let userId: String
    let findingReference: DocumentReference
}
