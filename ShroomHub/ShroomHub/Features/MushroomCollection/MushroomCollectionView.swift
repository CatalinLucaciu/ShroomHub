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
    @State private var selectedMushroom: CollectedMushroom?
    @State private var state: LoadableState<[CollectedMushroom], Error> = .idle
    
    init(viewModel: MushroomCollectionViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        AsyncView(
            $state,
            task: viewModel.getSavedMushrooms) { collection in
                if let collection {
                    content(for: collection)
                }
        }
            .onAppear {
                state = .idle
            }
        .sheet(item: $selectedMushroom) { mushroom in
            MushroomSpeciesDetailsView(mushroomSpecies: mushroom.species,
                                       mushroomFinding: mushroom.record,
                                       location: mushroom.location,
                                       locationURL: mushroom.locationURL)
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
        let imageURL = URL(string: record.imageUrl)
        let configuration = MushroomFindingCell.Configuration.init(
            image: .remote(imageURL), // aici daca vreau mock
            title: species.commonNames.first ?? species.scientificName,
            subtitle: species.scientificName,
            preFooter: collectedMushroom.location ?? "",
            footer: Date(timeIntervalSince1970: TimeInterval(record.timestamp))
                .formatted(.dateTime.month().day().hour().minute()),
            preFooterImage: locationSystemImage,
            footerImage: calendarSystemImage,
            action: {
                selectedMushroom = collectedMushroom
            }
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
