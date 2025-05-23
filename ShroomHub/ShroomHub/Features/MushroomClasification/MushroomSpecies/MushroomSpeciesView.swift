//
//  MushroomSpeciesView.swift
//  ShroomHub
//
//  Created by Catalin Lucaciu on 27.04.2025.
//

import SwiftUI
import ShroomHubDesignLibrary
import SHUtils
import SDWebImageSwiftUI

private enum Constants {
    static let imageSize: CGFloat = 200
}

public struct MushroomSpeciesView: View {
    @State private var viewModel: MushroomSpeciesViewModel
    @State private var isActionSheetPresented = false
    @State private var postState: LoadableState<Void, Error> = .idle
    @State private var saveState: LoadableState<Void, Error> = .idle
    @State private var isMessageSheetPresented = false
    @State private var selectedDetent: PresentationDetent = .medium
    
    init(viewModel: MushroomSpeciesViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        AsyncView(task: viewModel.fetchSpecies) { species in
            content(for: species)
        }
        .background(SHColor.mainBackground)
        .toolbar(.hidden, for: .tabBar)
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    isActionSheetPresented = true
                } label: {
                    Image(systemName: "square.and.arrow.up")
                }
            }
        })
        .navigationTitle(screenTitle)
    }
}


// MARK: - Views
private extension MushroomSpeciesView {
    @ViewBuilder
    func content(for species: MushroomSpecies) -> some View {
        ScrollView() {
            VStack(spacing: Spacing.small) {
                Image(uiImage: viewModel.classificationResult.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
                photosSection(for: species.images)
                namesSection(for: species)
                edibilitySection(for: species.edibility)
                seasonSection(for: species.season)
                habitatSection(for: species.habitat)
                lookalikesSection(for: species.lookalikes)
                notesSection(for: species.notes)
                taxonomySection(for: species.taxonomy)
                morphologySection(for: species.morphology)
                Spacer()
            }
            .padding(.horizontal, Spacing.small)
            .padding(.vertical, Spacing.medium)
        }
        .succesView(state: $postState,
                    animationName: animationName,
                    succesString: postSuccessMessage
        )
        .loadingView(state: saveState)
        .loadingView(state: postState)
        .alert(state: $postState)
        .scrollIndicators(.hidden)
        .succesView(state: $saveState,
                    animationName: animationName,
                    succesString: saveSuccessMessage
        )
        .sheet(isPresented: $isMessageSheetPresented,
               content: {
            TextInputView { message in
                Task {
                    await $postState.load {
                        try await viewModel.createMushroomPost(for: species, message: message)
                    }
                }
            }
            .presentationDetents([.medium], selection: $selectedDetent)
            .presentationDragIndicator(.hidden)
        })
        .alert(state: $saveState)
        .alert(state: $postState)
        .confirmationDialog(
            "Details",
            isPresented: $isActionSheetPresented,
            titleVisibility: .visible,
            actions: {
            Button(postButtonTitle) {
                isMessageSheetPresented.toggle()
            }
            Button(saveButtonTitle) {
                Task {
                    await $saveState.load {
                        try await viewModel.saveMushroom(for: species)
                    }
                }
            }
        })
    }
    
    @ViewBuilder
    func namesSection(for species: MushroomSpecies) -> some View {
        SectionView(
            title: species.scientificName,
            icon: .system(namesSectionIcon)) {
                VStack(spacing: Spacing.small) {
                    Text(species.commonNames.joined(separator: ", "))
                        .font(.regular14)
                        .foregroundStyle(SHColor.black)
                }
            }
    }
    
    @ViewBuilder
    func taxonomySection(for taxonomy: MushroomSpecies.Taxonomy) -> some View {
        let taxonomySections = viewModel.mapTaxonomyItems(from: taxonomy)
        SectionView(
            title: taxonomySectionTitle,
            icon: .system(taxonomySectionIcon)) {
                LazyVStack() {
                    ForEach(taxonomySections) { section in
                        HStack {
                            Text(section.key)
                                .font(.bold14)
                                .foregroundStyle(SHColor.mediumGray)
                            Spacer()
                            Text(section.value)
                                .multilineTextAlignment(.leading)
                                .font(.regular14)
                                .foregroundStyle(SHColor.black)
                        }
                    }
                }
            }
    }
    
    @ViewBuilder
    func morphologySection(for morphology: MushroomSpecies.Morphology) -> some View {
        let morphologySectionItems = viewModel.mapMorphologyItems(from: morphology)
        SectionView(
            title: morphologySectionTitle,
            icon: .system(morphologySectionIcon)) {
                LazyVStack(spacing: Spacing.small) {
                    ForEach(morphologySectionItems) { section in
                        VStack(alignment: .leading) {
                            HStack(alignment: .top, spacing: Spacing.small) {
                                Text(section.key)
                                    .font(.bold14)
                                    .foregroundStyle(SHColor.mediumGray)
                                    .frame(width: 50, alignment: .leading)
                                Text(section.value)
                                    .multilineTextAlignment(.leading)
                                    .font(.regular14)
                                    .foregroundStyle(SHColor.black)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            Divider()
                                .background(SHColor.lightGray)
                                .padding(.vertical, 4)
                        }
                    }
                }
            }
    }
    
    @ViewBuilder
    func habitatSection(for habitat: MushroomSpecies.Habitat) -> some View {
        SectionView(
            title: habitatSectionTitle,
            icon: .system(habitatSectionIcon)) {
                VStack(spacing: Spacing.small) {
                    Text("\(habitat.distribution) \(habitat.environment)")
                        .font(.regular14)
                        .foregroundStyle(SHColor.black)
                }
            }
    }
    
    @ViewBuilder
    func edibilitySection(for edibility: MushroomSpecies.Edibility) -> some View {
        SectionView(
            title: edibilitySectionTitle,
            icon: .system(edibilitySectionIcon)) {
                VStack(alignment: .leading, spacing: Spacing.small) {
                    HStack(spacing: Spacing.small) {
                        HStack {
                            Image(systemName: edibilityIcon)
                                .foregroundStyle(SHColor.edibleGreen)
                            Text(edibilityKey)
                                .font(.bold14)
                                .foregroundStyle(SHColor.black)
                            Image(systemName: edibility.isEdible ? yesIcon : noIcon)
                                .foregroundStyle(edibility.isEdible ? SHColor.edibleGreen : SHColor.toxicRed)
                        }
                        Spacer()
                        HStack {
                            Image(systemName: psychoactiveIcon)
                                .foregroundStyle(SHColor.psychoactiveYellow)
                            Text(psychoactiveKey)
                                .font(.bold14)
                                .foregroundStyle(SHColor.black)
                            Image(systemName: edibility.isPsychoactive ? yesIcon : noIcon)
                                .foregroundStyle(edibility.isPsychoactive ? SHColor.psychoactiveYellow : SHColor.edibleGreen)
                        }
                    }
                    VStack(alignment: .leading, spacing: Spacing.small) {
                        HStack {
                            Text(consumptionNotesKey)
                                .font(.bold14)
                                .foregroundStyle(SHColor.black)
                            Image(systemName: toxicityIcon)
                                .foregroundStyle(SHColor.toxicRed)
                        }
                        Text(edibility.toxicity)
                            .font(.regular14)
                            .foregroundStyle(SHColor.black)
                    }
                }
            }
    }
    
    @ViewBuilder
    func notesSection(for notes: String) -> some View {
        SectionView(
            title: notesSectionTitle,
            icon: .system(notesSectionIcon)
        ) {
            Text(notes)
                .font(.regular14)
                .foregroundStyle(SHColor.black)
                .multilineTextAlignment(.leading)
        }
    }
    
    @ViewBuilder
    func seasonSection(for season: String) -> some View {
        SectionView(
            title: seasonSectionTitle,
            icon: .system(seasonSectionIcon)
        ) {
            Text(season)
                .font(.regular14)
                .foregroundStyle(SHColor.black)
        }
    }
    
    @ViewBuilder
    func lookalikesSection(for lookalikes: [String]) -> some View {
        SectionView(
            title: lookalikesSectionTitle,
            icon: .system(lookalikesSectionIcon)
        ) {
            Text(lookalikes.joined(separator: ", "))
                .font(.regular14)
                .multilineTextAlignment(.leading)
                .foregroundStyle(SHColor.black)
        }
    }
    
    @ViewBuilder
    func photosSection(for images: [String]) -> some View {
        SectionView(
            title: imagesSectionTitle,
            icon: .system(imagesSectionIcon)
        ) {
            ScrollView(.horizontal) {
                LazyHStack(spacing: Spacing.small) {
                    ForEach(images, id: \.self) { image in
                        imageView(for: image)
                    }
                }
            }
            .scrollTargetBehavior(.paging)
        }
    }
    
    @ViewBuilder
    func imageView(for imageString: String) -> some View {
        let url = URL(string: imageString)
        WebImage(url: url) { image in
            image
                .resizable()
                .scaledToFill()
                .frame(width: Constants.imageSize, height: Constants.imageSize)
        } placeholder: {
            Image(systemName: "photo.fill")
                .resizable()
                .scaledToFill()
                .frame(width: Constants.imageSize, height: Constants.imageSize)
                .foregroundStyle(.gray)
                .opacity(0.5)
        }
        .cornerRadius(CornerRadius.medium)
    }
}

// MARK: - Strings
private extension MushroomSpeciesView {
    var screenTitle: String {
        viewModel.classificationResult.speciesName.replacingOccurrences(of: "_", with: " ")
    }
    
    var saveSuccessMessage: String {
        "Saved to your collection!"
    }

    var postSuccessMessage: String {
        "Shared with the community!"
    }
    
    var imagesSectionTitle: String {
        "Photos"
    }
    
    var namesSectionTitle: String {
        "Names"
    }
    
    var taxonomySectionTitle: String {
        "Taxonomy"
    }
    
    var morphologySectionTitle: String {
        "Morphology"
    }
    
    var habitatSectionTitle: String {
        "Habitat & Distribution"
    }
    
    var edibilitySectionTitle: String {
        "Consumption"
    }
    
    var lookalikesSectionTitle: String {
        "Lookalikes"
    }
    
    var notesSectionTitle: String {
        "Notes"
    }
    
    var seasonSectionTitle: String {
        "Season"
    }
    
    var edibilityKey: String {
        "Edible"
    }
    
    var psychoactiveKey: String {
        "Psychoactive"
    }
    
    var consumptionNotesKey: String {
        "Consumption Notes"
    }
    
    var postButtonTitle: String {
        "Create a Post"
    }
    
    var saveButtonTitle: String {
        "Save to My Mushrooms"
    }
}

// MARK: - Icons
private extension MushroomSpeciesView {
    var imagesSectionIcon: String {
        "photo.on.rectangle"
    }
    
    var namesSectionIcon: String {
        "leaf"
    }
    
    var taxonomySectionIcon: String {
        "chart.bar.doc.horizontal.fill"
    }
    
    var morphologySectionIcon: String {
        "circle.hexagongrid.fill"
    }
    
    var habitatSectionIcon: String {
        "globe.europe.africa"
    }
    
    var edibilitySectionIcon: String {
        "fork.knife"
    }
    
    var lookalikesSectionIcon: String {
        "eye.trianglebadge.exclamationmark"
    }
    
    var notesSectionIcon: String {
        "note.text"
    }
    
    var seasonSectionIcon: String {
        "calendar"
    }
    
    var edibilityIcon: String {
        "takeoutbag.and.cup.and.straw.fill"
    }
    
    var psychoactiveIcon: String {
        "brain.head.profile"
    }
    
    var toxicityIcon: String {
        "exclamationmark.triangle.fill"
    }
    
    var yesIcon: String {
        "checkmark.square.fill"
    }
    
    var noIcon: String {
        "x.square.fill"
    }
}

// MARK: - Animation
extension MushroomSpeciesView {
    var animationName: String {
        "mushroom_success_animation"
    }
}
