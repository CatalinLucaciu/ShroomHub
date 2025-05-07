//
//  ObjectCaptureViewFactory.swift
//  ShroomHub
//
//  Created by Catalin Lucaciu on 27.04.2025.
//

import SwiftUI

struct ObjectCaptureViewFactory {
    @ViewBuilder
    func makeView(for destination: ObjectCaptureTabDestination) -> some View {
        switch destination {
        case .objectCapture:
            Text("placeholder")
        }
    }
}
