//
//  AuthenticationViewFactory.swift
//  ShroomHub
//
//  Created by Catalin Lucaciu on 15.03.2025.
//

import SwiftUI
import FirebaseAuthPackage
import SHNavigation

struct AuthenticationViewFactory {
    private let authManager: FirebaseAuthenticator
    
    init(authManager: FirebaseAuthenticator) {
        self.authManager = authManager
    }
    
    @ViewBuilder
    func makeView(for destination: AppRootDestination) -> some View {
        switch destination {
        case .register:
            RegisterView(authManager: authManager)
        case .login:
            LoginView(authManager: authManager)
        case .dashboard:
            DashboardView()
                .navigationBarBackButtonHidden(true)
        }
    }
}
