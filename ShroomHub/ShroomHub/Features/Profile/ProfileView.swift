//
//  ProfileView.swift
//  ShroomHub
//
//  Created by Catalin Lucaciu on 16.03.2025.
//

import SwiftUI
import FirebaseAuthPackage
import CSRNetworkService
import ShroomHubDesignLibrary

struct ProfileView: View {
    let authenticator = FirebaseAuthenticator()
    @EnvironmentObject var session: AppSession
    @State var viewModel: MushroomCollectionViewModel
    
    var body: some View {
        VStack {
            MushroomCollectionView(viewModel: viewModel)
        }
//        Button("SignOut") {
//            Task {
//                try? await authenticator.signOut()
//            }
//        }
    }
}
