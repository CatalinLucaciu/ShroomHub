//
//  MushroomClassificationResult.swift
//  ShroomHub
//
//  Created by Catalin Lucaciu on 07.05.2025.
//

import Foundation
import UIKit

struct MushroomClassificationResult: Hashable, Identifiable {
    let id: String = UUID().uuidString
    let speciesName: String
    let image: UIImage
}
