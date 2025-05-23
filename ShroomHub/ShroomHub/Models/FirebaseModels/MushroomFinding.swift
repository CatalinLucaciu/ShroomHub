//
//  MushroomFinding.swift
//  ShroomHub
//
//  Created by Catalin Lucaciu on 11.05.2025.
//

import FirebaseFirestore
import Foundation

struct MushroomFinding: Codable, Hashable {
    @DocumentID var id: String?
    let userId: String
    let speciesReference: DocumentReference
    let timestamp: Int
    let location: GeoPoint
    let altitude: Double
    let imageUrl: String
}
