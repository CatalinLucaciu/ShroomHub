//
//  MushroomMapView.swift
//  ShroomHub
//
//  Created by Catalin Lucaciu on 07.06.2025.
//

import SwiftUI
import ShroomHubDesignLibrary
import SHUtils
import MapKit

struct MushroomMapView: View {
    @State private var cameraPosition: MapCameraPosition = .automatic
    @State private var viewModel: MushroomMapViewModel
    @State private var selectedMapItem: MKMapItem?
    @State private var selectedMushroom: CollectedMushroom?
    
    init(viewModel: MushroomMapViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        AsyncView(task: viewModel.getCollectedMushrooms) { mushrooms in
            content(for: mushrooms)
        }
        .sheet(item: $selectedMushroom) { mushroom in
            MushroomSpeciesDetailsView(mushroomSpecies: mushroom.species, mushroomFinding: mushroom.record)
        }
    }
}


// MARK: - Views
private extension MushroomMapView {
    @ViewBuilder
    func content(for collectedMushrooms: [CollectedMushroom]) -> some View {
        Map(position: $cameraPosition, selection: $selectedMushroom) {
               ForEach(collectedMushrooms) { mushroom in
                   Marker(
                       mushroom.species.scientificName,
                       systemImage: "mushroom.fill",
                       coordinate: mushroom.coordinate
                   )
                   .tag(mushroom)
                   .tint(.red)
                   .mapItemDetailSelectionAccessory(.sheet)
               }
           }
        .onAppear {
            let coordinates = collectedMushrooms.map(\.coordinate)
            let region = MKCoordinateRegion.region(
                for: coordinates,
                fallback: viewModel.currentLocation
            )
            withAnimation {
                cameraPosition = .region(region)
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}
