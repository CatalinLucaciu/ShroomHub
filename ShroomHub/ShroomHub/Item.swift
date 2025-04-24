//
//  Item.swift
//  ShroomHub
//
//  Created by Catalin Lucaciu on 25.02.2025.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
