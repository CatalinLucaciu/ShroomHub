//
//  RegisterView.swift
//  ShroomHub
//
//  Created by Catalin Lucaciu on 04.03.2025.
//

import SwiftUI
import ShroomHubDesignLibrary
import FirebaseAuthPackage
import SHUtils
import SHNavigation
import CSRNetworkService
import CSRImageClassifier

private enum Constants {
    static let imageSize: CGFloat = 70
}

struct RegisterView: View {
    @State private var viewModel: RegisterViewModel
    @EnvironmentObject private var router: NavigationRouter
    @EnvironmentObject private var appSession: AppSession
    @State private var isPasswordVisible: Bool = false
    @State private var showCameraPicker: Bool = false
    @State private var showPhotoLibraryPicker: Bool = false
    @State private var registerState: LoadableState<Void, Error> = .idle
    
    init(viewModel: RegisterViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.medium) {
            Text(header)
                .font(.bold30)
            Text(subHeadear)
                .font(.regular16)
            emailField
            nameField
            passwordField
            loginShortcut
                .frame(maxWidth: .infinity, alignment: .center)
            uploadAvatarImage
                .frame(maxWidth: .infinity, alignment: .center)
            Spacer()
            signUpButton
        }
        .succesView(
            state: $registerState,
            animationName: animationName,
            succesString: registrationSuccesString,
            completion: {
                appSession.isUserCreationFinished = true
            })
        .sheet(isPresented: $showCameraPicker, content: {
            CameraPicker { image, _, _ in
                viewModel.setAvatarImageData(data: image.jpegData(compressionQuality: 0.8))
            }
        })
        .sheet(isPresented: $showPhotoLibraryPicker, content: {
            PhotoLibraryPicker { image in
                viewModel.setAvatarImageData(data: image.jpegData(compressionQuality: 0.8))
            }
        })
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, Spacing.medium)
        .padding(.horizontal, Spacing.medium)
    }
}

// MARK: - Views
private extension RegisterView {
    @ViewBuilder
    var emailField: some View {
        VStack(alignment: .leading) {
            Text("Email")
                .font(.bold16)
            HStack {
                Image(systemName: "envelope")
                    .foregroundColor(SHColor.forestGreen)
                TextField(text: $viewModel.email) {
                    Text("Email")
                        .font(.bold14)
                        .foregroundStyle(SHColor.forestGreen)
                }
                .foregroundStyle(SHColor.forestGreen)
                .autocapitalization(.none)
                .keyboardType(.emailAddress)
            }
            .padding()
            .background(SHColor.mistWhite)
            .cornerRadius(CornerRadius.medium)
        }
    }
    
    @ViewBuilder
    var nameField: some View {
        VStack(alignment: .leading) {
            Text("Name")
                .font(.bold16)
            HStack {
                Image(systemName: "person")
                    .foregroundColor(SHColor.forestGreen)
                TextField(text: $viewModel.name) {
                    Text("Name")
                        .font(.bold14)
                        .foregroundStyle(SHColor.forestGreen)
                }
                .foregroundStyle(SHColor.forestGreen)
                .autocapitalization(.none)
                .keyboardType(.default)
            }
            .padding()
            .background(SHColor.mistWhite)
            .cornerRadius(CornerRadius.medium)
        }
    }
    
    @ViewBuilder
    var passwordField: some View {
        VStack(alignment: .leading) {
            Text("Password")
                .font(.bold16)
            HStack {
                Image(systemName: "lock")
                    .foregroundStyle(SHColor.forestGreen)
                if isPasswordVisible {
                    TextField(text: $viewModel.password) {
                        Text("Password")
                            .font(.bold14)
                            .foregroundStyle(SHColor.forestGreen)
                    }
                } else {
                    SecureField(text: $viewModel.password) {
                        Text("Password")
                            .font(.bold14)
                            .foregroundStyle(SHColor.forestGreen)
                    }
                }
                Spacer()
                Button {
                    isPasswordVisible.toggle()
                } label: {
                    Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                        .foregroundStyle(SHColor.forestGreen)
                }
            }
            .padding()
            .background(SHColor.mistWhite)
            .cornerRadius(CornerRadius.medium)
        }
    }
    
    @ViewBuilder
    var loginShortcut: some View {
        HStack {
            Text(alreadyHaveAnAccount)
                .font(.regular14)
            NavigationLink(value: AppRootDestination.login) {
                Text(loginString)
                    .font(.bold14)
                    .foregroundStyle(SHColor.forestGreen)
            }
        }
    }
    
    @ViewBuilder
    var divider: some View {
        HStack(spacing: Spacing.small) {
            Rectangle()
                .foregroundStyle(SHColor.lightGray)
                .frame(height: 1)
            Text(dividerString)
            Rectangle()
                .foregroundStyle(SHColor.lightGray)
                .frame(height: 1)
        }
        .frame(maxWidth: .infinity)
    }
    
    @ViewBuilder
    var signUpButton: some View {
        SHLoadableButton(
            label: {
                Text(registerString)
            },
            state: $registerState,
            style: .primary,
            isDisabled: !viewModel.areFieldsCompleted) {
                await $registerState.load {
                    try await viewModel.createUser()
                }
            }
    }
    
    @ViewBuilder
    var uploadAvatarImage: some View {
        VStack(alignment: .center, spacing: Spacing.medium) {
            Text(profilePickInformative)
                .font(.bold18)
                .foregroundStyle(SHColor.forestGreen)
            HStack(spacing: Spacing.medium) {
                Button {
                    showCameraPicker.toggle()
                } label: {
                    VStack {
                        Image(systemName: "camera")
                            .resizable()
                            .frame(width: Constants.imageSize, height: Constants.imageSize)
                        Text(cameraButtonTitle)
                            .font(.regular14)
                    }
                }
                .tint(SHColor.forestGreen)
                
                Button {
                    showPhotoLibraryPicker.toggle()
                } label: {
                    VStack {
                        Image(systemName: "photo.on.rectangle")
                            .resizable()
                            .frame(width: Constants.imageSize, height: Constants.imageSize)
                        Text(photoLibraryButtonTitle)
                            .font(.regular14)
                    }
                }
                .tint(SHColor.forestGreen)
            }
        }
    }
}

// MARK: - Strings
private extension RegisterView {
    var header: String {
        "Join ShroomHub Today"
    }
    
    var subHeadear: String {
        "Create your foraging account"
    }
    
    var alreadyHaveAnAccount: String {
        "Already have an account?"
    }
    
    var registerString: String {
        "Sign up"
    }
    
    var loginString: String {
        "Log in"
    }
    
    var dividerString: String {
        "or"
    }
    
    var profilePickInformative: String {
        "Upload Profile Picture"
    }
    
    var cameraButtonTitle: String {
        "Take Photo"
    }
    
    var photoLibraryButtonTitle: String {
        "Choose from Library"
    }
    
    var animationName: String {
        "mushroom_success_animation"
    }
    
    var registrationSuccesString: String {
        "Registration successful. Welcome aboard!"
    }
}

#Preview {
    let viewModel = RegisterViewModel(authManager: FirebaseAuthenticator(), userService: UserService(networkService: NetworkService()), appSession: AppSession())
    RegisterView(viewModel: viewModel)
}
