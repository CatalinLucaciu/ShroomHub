//
//  MushroomSpeciesDetailsView.swift
//  ShroomHub
//
//  Created by Catalin Lucaciu on 07.06.2025.
//

import SwiftUI
import ShroomHubDesignLibrary
import SHUtils
import SDWebImageSwiftUI

private enum Constants {
    static let carouselImageSize: CGFloat = 200
    static let capturedImageSize: CGFloat = 250
}

public struct MushroomSpeciesDetailsView: View {
    let mushroomSpecies: MushroomSpecies
    let mushroomFinding: MushroomFinding?
    let location: String?
    let locationURL: URL?
    
    init(
        mushroomSpecies: MushroomSpecies,
        mushroomFinding: MushroomFinding? = nil,
        location: String? = nil,
        locationURL: URL? = nil) {
            self.mushroomSpecies = mushroomSpecies
            self.mushroomFinding = mushroomFinding
            self.location = location
            self.locationURL = locationURL
        }
    
    public var body: some View {
        content(for: mushroomSpecies)
    }
}


// MARK: - Views
private extension MushroomSpeciesDetailsView {
    @ViewBuilder
    func content(for species: MushroomSpecies) -> some View {
        ScrollView() {
            VStack(spacing: Spacing.small) {
                if let mushroomFinding {
                    capturedImageSection(for: mushroomFinding)
                }
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
        .scrollIndicators(.hidden)
    }
    
    @ViewBuilder
    func capturedImageSection(for mushroomFinding: MushroomFinding) -> some View {
        let url = URL(string: mushroomFinding.imageUrl)
        SectionView(title: capturedImageSectionTitle, icon: .system(capturedImageSectionIcon)) {
            VStack {
                WebImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    Image(systemName: "photo.fill")
                        .resizable()
                        .scaledToFill()
                        .foregroundStyle(.gray)
                        .opacity(0.5)
                }
                .frame(maxWidth: .infinity)
                .frame(height: Constants.capturedImageSize)
                .clipped()
                .cornerRadius(CornerRadius.medium)
                if let location, let locationURL {
                    HStack {
                        LocationView(locationName: location, locationUrl: locationURL)
                        Spacer()
                    }
                }
            }
            
        }
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
        let taxonomySections = mapTaxonomyItems(from: taxonomy)
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
        let morphologySectionItems = mapMorphologyItems(from: morphology)
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
                        imageView(
                            for: image,
                            width: Constants.carouselImageSize,
                            height: Constants.carouselImageSize
                        )
                    }
                }
            }
            .scrollTargetBehavior(.paging)
        }
    }
    
    @ViewBuilder
    func imageView(
        for imageString: String,
        width: CGFloat,
        height: CGFloat
    ) -> some View {
        let url = URL(string: imageString)
        WebImage(url: url) { image in
            image
                .resizable()
                .frame(width: width, height: height)
                .scaledToFill()
        } placeholder: {
            Image(systemName: "photo.fill")
                .resizable()
                .frame(width: width, height: height)
                .scaledToFill()
                .foregroundStyle(.gray)
                .opacity(0.5)
        }
        .cornerRadius(CornerRadius.medium)
    }
}

// MARK: - Strings
private extension MushroomSpeciesDetailsView {
    var screenTitle: String {
        mushroomSpecies.scientificName.replacingOccurrences(of: "_", with: " ")
    }
    
    var capturedImageSectionTitle: String {
        "Captured Photo"
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
private extension MushroomSpeciesDetailsView {
    var capturedImageSectionIcon: String {
        "camera.viewfinder"
    }
    
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
extension MushroomSpeciesDetailsView {
    var animationName: String {
        "mushroom_success_animation"
    }
}

// MARK: - Utils
private extension MushroomSpeciesDetailsView {
    func mapMorphologyItems(from morphology: MushroomSpecies.Morphology) -> [EnumerationSectionItem] {
        var morphologyItems: [EnumerationSectionItem] = []
        if let cap = morphology.cap {
            let capItem = EnumerationSectionItem(key: capKey, value: cap)
            morphologyItems.append(capItem)
        }
        if let gills = morphology.gills {
            let gillsItem = EnumerationSectionItem(key: gillsKey, value: gills)
            morphologyItems.append(gillsItem)
        }
        if let stem = morphology.stem {
            let stemItem = EnumerationSectionItem(key: stemKey, value: stem)
            morphologyItems.append(stemItem)
        }
        if let flesh = morphology.flesh {
            let fleshItem = EnumerationSectionItem(key: fleshKey, value: flesh)
            morphologyItems.append(fleshItem)
        }
        return morphologyItems
    }
    
    func mapTaxonomyItems(from taxonomy: MushroomSpecies.Taxonomy) -> [EnumerationSectionItem] {
        [
            EnumerationSectionItem(key: kingdomKey, value: taxonomy.kingdom),
            EnumerationSectionItem(key: phylumKey, value: taxonomy.phylum),
            EnumerationSectionItem(key: classKey, value: taxonomy.taxonomyClass),
            EnumerationSectionItem(key: orderKey, value: taxonomy.order),
            EnumerationSectionItem(key: familyKey, value: taxonomy.family),
            EnumerationSectionItem(key: genusKey, value: taxonomy.genus)
        ]
    }
}

// MARK: - Morphology Keys
private extension MushroomSpeciesDetailsView {
    var capKey: String {
        "Cap"
    }
    
    var gillsKey: String {
        "Gills"
    }
    
    var stemKey: String {
        "Stem"
    }
    
    var fleshKey: String {
        "Flesh"
    }
}

// MARK: - Taxonomy Keys
private extension MushroomSpeciesDetailsView {
    var kingdomKey: String {
        "Kingdom"
    }
    
    var phylumKey: String {
        "Phylum"
    }
    
    var classKey: String {
        "Class"
    }
    
    var orderKey: String {
        "Order"
    }
    
    var familyKey: String {
        "Family"
    }
    
    var genusKey: String {
        "Genus"
    }
}

