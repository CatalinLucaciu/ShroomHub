//
//  HomeView.swift
//  ShroomHub
//
//  Created by Catalin Lucaciu on 16.03.2025.
//

import SwiftUI
import ShroomHubDesignLibrary

struct HomeView: View {
    @State private var viewModel: HomeViewModel
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        AsyncView(task: viewModel.getFeed) { posts in
            content(for: posts)
        }
        .navigationTitle(screenTitle)
        .navigationBarTitleDisplayMode(.inline)
        .background(SHColor.mainBackground)
    }
}

// MARK: - Views
private extension HomeView {
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
            postImageString: post.finding.imageUrl,
            name: post.userDetails.name,
            subName: post.postDetails.formatedDateString,
            description: post.postDetails.message
        )
        FeedPostView(
            likeCount: post.postDetails.likeCount,
            commentCount: post.postDetails.commentCount,
            configuration: configuration,
            subHeaderContent: {
                LocationView(locationName: post.location, locationUrl: post.locationURL)
            },
            leftFooterContent: {
                Text("not implemented")
            },
            likeButtonAction: {
                print("like")
            },
            commentButtonAction: {
                print("comment")
            }
        )
    }
}

// MARK: - Strings
private extension HomeView {
    var screenTitle: String {
        "Post Feed"
    }
}
