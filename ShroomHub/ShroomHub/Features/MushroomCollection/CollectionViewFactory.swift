//
//  CollectionViewFactory.swift
//  ShroomHub
//
//  Created by Catalin Lucaciu on 27.04.2025.
//

import SwiftUI

struct CollectionViewFactory {
    @ViewBuilder
    func makeView(for destination: CollectionTabDestination) -> some View {
        switch destination {
        case .profile:
            Text("placeholder")
        }
    }
}
