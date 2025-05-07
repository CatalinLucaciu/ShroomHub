//
//  ProfileViewFactory.swift
//  ShroomHub
//
//  Created by Catalin Lucaciu on 27.04.2025.
//

import SwiftUI

struct ProfileViewFactory {
    @ViewBuilder
    func makeView(for destination: ProfileTabDestination) -> some View {
        switch destination {
        case .profile:
            Text("placeholder")
        }
    }
}
