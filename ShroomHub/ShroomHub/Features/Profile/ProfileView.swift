//
//  ProfileView.swift
//  ShroomHub
//
//  Created by Catalin Lucaciu on 16.03.2025.
//

import SwiftUI
import FirebaseAuthPackage

struct ProfileView: View {
    let authenticator = FirebaseAuthenticator()
    var body: some View {
        Button("SignOut") {
            Task {
                try? await authenticator.signOut()
            }
        }
    }
}

#Preview {
    ProfileView()
}
