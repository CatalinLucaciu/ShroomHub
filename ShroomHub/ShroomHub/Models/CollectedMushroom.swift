//
//  CollectedMushroom.swift
//  ShroomHub
//
//  Created by Catalin Lucaciu on 14.05.2025.
//

import Foundation
import MapKit

struct CollectedMushroom: Identifiable, Hashable {
    var id = UUID()
    let record: MushroomFinding
    let species: MushroomSpecies
    let location: String?
    let locationURL: URL?
}
