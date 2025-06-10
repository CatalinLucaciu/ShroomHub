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
        .customBackButton()
        .background(SHColor.mainBackground)
        .toolbar(.hidden, for: .tabBar)
        .toolbar(content: {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    isActionSheetPresented = true
                } label: {
                    Image(systemName: shareIcon)
                        .foregroundStyle(SHColor.forestGreen)
                }
            }
        })
        .navigationTitle(screenTitle)
        .navigationBarTitleDisplayMode(.inline)
    }
}


// MARK: - Views
private extension MushroomSpeciesView {
    @ViewBuilder
    func content(for species: MushroomSpecies) -> some View {
        MushroomSpeciesDetailsView(mushroomSpecies: species)
        .succesView(state: $postState,
                    animationName: animationName,
                    succesString: postSuccessMessage
        )
        .loadingView(state: saveState)
        .loadingView(state: postState)
        .alert(state: $postState)
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
            confirmationDialogTitle,
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
    
    var confirmationDialogTitle: String {
        "Choose an Option"
    }
    
    var saveSuccessMessage: String {
        "Saved to your collection!"
    }

    var postSuccessMessage: String {
        "Shared with the community!"
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
    var shareIcon: String {
        "square.and.arrow.up"
    }
}

// MARK: - Animation
extension MushroomSpeciesView {
    var animationName: String {
        "mushroom_success_animation"
    }
}
