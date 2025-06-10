//
//  HomeView.swift
//  ShroomHub
//
//  Created by Catalin Lucaciu on 16.03.2025.
//

import SwiftUI
import ShroomHubDesignLibrary
import SHNavigation
import CSRImageClassifier

private enum Constants {
    static let imageSize: CGFloat = 25
    static let drawerWidth: CGFloat = 250
}

struct HomeView: View {
    @State private var viewModel: HomeViewModel
    @EnvironmentObject private var navigationRouter: NavigationRouter
    @State private var shouldShowImageSourceSelection = false
    @State private var selectedImageSource: ClassificationImageSource?
    @State private var isMenuPresented = false
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        content
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    cameraButton
                }
                ToolbarItem(placement: .topBarLeading) {
                    menuButton
                }
            }
            .fullScreenCover(item: $selectedImageSource) { source in
                MushroomClasificationView(imageSource: source)
            }
            .confirmationDialog(dialogTitle,
                                isPresented: $shouldShowImageSourceSelection,
                                titleVisibility: .visible) {
                cameraPickerButton
                photoLibraryPickerButton
            }
                                .navigationTitle(screenTitle)
                                .navigationBarTitleDisplayMode(.inline)
                                .background(SHColor.mainBackground)
    }
}

// MARK: - Views
private extension HomeView {
    @ViewBuilder
    var content: some View {
        ZStack(alignment: .leading) {
            mainContent
                .drawerOverlay(isPresented: isMenuPresented) {
                    withAnimation { isMenuPresented = false }
                }
            
            if isMenuPresented {
                DrawerMenuView {
                    withAnimation { isMenuPresented = false }
                }
                .frame(width: Constants.drawerWidth)
                .transition(.move(edge: .leading))
            }
        }
    }
    
    var drawerMenu: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Profile")
                .font(.headline)
            Text("Settings")
                .font(.headline)
            Text("About")
                .font(.headline)
            Spacer()
        }
        .padding()
        .frame(maxHeight: .infinity)
        .background(SHColor.mistWhite)
    }
    
    var mainContent: some View {
        AsyncView(task: viewModel.getFeed) { posts in
            ScrollView {
                VStack(spacing: Spacing.small) {
                    ForEach(posts) { post in
                        postView(for: post)
                    }
                }
            }
        }
    }
    
    func content(for posts: [HomeFeedPost] ) -> some View {
        ScrollView {
            VStack(spacing: Spacing.small) {
                ForEach(posts) { post in
                    postView(for: post)
                }
            }
        }
    }
    
    @ViewBuilder
    func postView(for post: HomeFeedPost) -> some View {
        let profileUrl = post.userDetails.avatarURL.flatMap(URL.init)
        let configuration = FeedPostConfiguration.init(
            profileImageType: .remote(profileUrl),
            postImageString: post.collectedMushroom.record.imageUrl,
            name: post.userDetails.name,
            subName: post.postDetails.formatedDateString,
            description: post.postDetails.message
        )
        FeedPostView(
            likeCount: post.postDetails.likeCount,
            commentCount: post.postDetails.commentCount,
            configuration: configuration,
            leftSubHeaderContent: {
                Text(post.collectedMushroom.species.scientificName)
                    .font(.bold18)
                    .foregroundStyle(SHColor.forestGreen)
            },
            footerContent: {
                LocationView(locationName: post.collectedMushroom.location, locationUrl: post.collectedMushroom.locationURL)
            },
            likeButtonAction: {
                print("like")
            },
            commentButtonAction: {
                print("comment")
            }
        )
    }
    
    @ViewBuilder
    var cameraPickerButton: some View {
        Button {
            selectedImageSource = .camera
        } label: {
            HStack {
                Text(cameraPickerButtonTitle)
                Image(systemName: cameraPickerImage)
                    .resizable()
                    .foregroundStyle(SHColor.forestGreen)
                    .frame(width: Constants.imageSize, height: Constants.imageSize)
            }
        }
    }
    
    @ViewBuilder
    var photoLibraryPickerButton: some View {
        Button {
            selectedImageSource = .library
        } label: {
            HStack {
                Text(photoLibraryButtonTitle)
                Image(systemName: libraryPickerImage)
                    .resizable()
                    .frame(width: Constants.imageSize, height: Constants.imageSize)
            }
        }
    }
    
    @ViewBuilder
    var cameraButton: some View {
        Button {
            shouldShowImageSourceSelection.toggle()
        } label: {
            Image(systemName: toolBarItemImage)
                .foregroundStyle(SHColor.forestGreen)
        }
    }
    
    @ViewBuilder
    var menuButton: some View {
        Button {
            withAnimation {
                isMenuPresented.toggle()
            }
        } label: {
            Image(systemName: menuImage)
                .foregroundStyle(SHColor.forestGreen)
        }
    }
    
}

// MARK: - Strings
private extension HomeView {
    var screenTitle: String {
        "Post Feed"
    }
    var toolBarItemImage: String {
        "camera.fill"
    }
    var dialogTitle: String {
        "Choose the source of the image"
    }
    var photoLibraryButtonTitle: String {
        "Photo Library"
    }
    var cameraPickerButtonTitle: String {
        "Camera"
    }
}

// MARK: - Images
private extension HomeView {
    var menuImage: String {
        "line.3.horizontal"
    }
    
    var libraryPickerImage: String {
        "photo.on.rectangle"
    }
    
    var cameraPickerImage: String {
        "camera"
    }
}
