//
//  MushroomCollectionView.swift
//  ShroomHub
//
//  Created by Catalin Lucaciu on 13.05.2025.
//

import SwiftUI
import ShroomHubDesignLibrary
import CSRLocationService
import SHUtils

struct MushroomCollectionView: View {
    @State private var viewModel: MushroomCollectionViewModel
    @State private var reverseLocationState: LoadableState<ReverseGeocodedLocation?, Error> = .idle
    
    init(viewModel: MushroomCollectionViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        AsyncView(task: viewModel.getSavedMushrooms) { collection in
            content(for: collection)
        }
        .navigationTitle(screenTitle)
        .navigationBarTitleDisplayMode(.inline)
        .padding(.top, Spacing.small)
        .background(SHColor.mainBackground)
    }
}

// MARK: - Views
private extension MushroomCollectionView {
    @ViewBuilder
    func content(for collection: [CollectedMushroom]) -> some View {
        ScrollView {
            LazyVStack(spacing: Spacing.small) {
                ForEach(collection) { mushroom in
                    collectedMushroom(for: mushroom)
                        .background(SHColor.mainBackground)
                }
            }
            .padding(.horizontal, Spacing.medium)
            .padding(.vertical, Spacing.small)
        }
        .scrollIndicators(.hidden)
    }
    
    @ViewBuilder
    func collectedMushroom(for collectedMushroom: CollectedMushroom) -> some View {
        let record = collectedMushroom.record
        let species = collectedMushroom.species
        let imageURL = URL(string: record.imageUrl) // sa-l bag la loc
        let configuration = MushroomFindingCell.Configuration.init(
            image: .remote(nil), // aici
            title: species.commonNames.first ?? species.scientificName,
            subtitle: species.scientificName,
            preFooter: collectedMushroom.location ?? "",
            footer: Date(timeIntervalSince1970: TimeInterval(record.timestamp)).description,
            preFooterImage: locationSystemImage,
            footerImage: calendarSystemImage
        )
        MushroomFindingCell(configuration: configuration)
    }
}

// MARK: - Images
private extension MushroomCollectionView {
    var locationSystemImage: String {
        "location"
    }
    
    var calendarSystemImage: String {
        "calendar"
    }
}

// MARK: - Strings
private extension MushroomCollectionView {
    var screenTitle: String {
        "My Collection"
    }
}
