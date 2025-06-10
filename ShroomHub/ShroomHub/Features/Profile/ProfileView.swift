//
//  ProfileView.swift
//  ShroomHub
//
//  Created by Catalin Lucaciu on 16.03.2025.
//

import SwiftUI
import ShroomHubDesignLibrary
import SHUtils

private enum Constants {
    static let profilePictureSize: CGFloat = 200
}

struct ProfileView: View {
    @State private var viewModel: ProfileViewModel
    @State private var signOutState: LoadableState<Void, Error> = .idle
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        self.signOutState = signOutState
    }

    var body: some View {
        AsyncView(task: viewModel.getUserDetails) { user in
            content(for: user)
        }
        .padding(.bottom, Spacing.small)
        .background(SHColor.mainBackground)
    }
}

// MARK: - UI
private extension ProfileView {
    @ViewBuilder
    func content(for user: FireBaseUser) -> some View {
        VStack(spacing: Spacing.medium) {
            profilePicture(for: user)
            Text(user.name)
                .font(.title.bold())
                .foregroundColor(SHColor.forestGreen)

            Text(user.email)
                .font(.subheadline)
                .foregroundColor(SHColor.forestGreen)
            
            Spacer()

            signOutButton
        }
        .background(SHColor.mainBackground)
    }

    @ViewBuilder
    func profilePicture(for user: FireBaseUser) -> some View {
        AsyncImageRenderer(source: .remote(URL(string: user.avatarURL ?? ""))) { image in
            image
                .resizable()
                .scaledToFill()
                .frame(width: Constants.profilePictureSize, height: Constants.profilePictureSize)
                .clipShape(Circle())
                .overlay(Circle().stroke(SHColor.black, lineWidth: 2))
        } fallBack: {
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: Constants.profilePictureSize, height: Constants.profilePictureSize)
                .foregroundStyle(SHColor.mediumGray)
                .clipShape(Circle())
                .overlay(Circle().stroke(SHColor.black, lineWidth: 2))
        }
    }

    var signOutButton: some View {
        SHLoadableButton(
            label: { Text(signoutString) },
            state: $signOutState,
            style: .primary
        ) {
            await $signOutState.load {
                try await viewModel.signOut()
            }
        }
    }
}

// MARK: - Strings
private extension ProfileView {
    var signoutString: String {
        "Sign Out"
    }
    
    var animationName: String {
        "mushroom_success_animation"
    }
    
    var succesViewMessage: String {
        "Signed out successfully."
    }
}
