//
//  HomeViewFactory.swift
//  ShroomHub
//
//  Created by Catalin Lucaciu on 27.04.2025.
//

import SwiftUI

struct HomeViewFactory {
    @ViewBuilder
    func makeView(for destination: HomeTabDestination) -> some View {
        switch destination {
        case .homeScreen:
            Text("placeholder")
        }
    }
}
