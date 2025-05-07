//
//  MushroomCaptureView.swift
//  ShroomHub
//
//  Created by Catalin Lucaciu on 16.03.2025.
//

import SwiftUI
import CSRObjectCapture

struct MushroomCaptureView: View {
    var body: some View {
        content
    }
}


private extension MushroomCaptureView {
    @ViewBuilder
    var content: some View {
        ScannerView()
            .environment(AppDataModel.instance)
    }
}

#Preview {
    MushroomCaptureView()
}
