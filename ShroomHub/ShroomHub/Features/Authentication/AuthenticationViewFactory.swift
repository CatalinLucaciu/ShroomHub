//
//  AuthenticationViewFactory.swift
//  ShroomHub
//
//  Created by Catalin Lucaciu on 15.03.2025.
//

import SwiftUI
import FirebaseAuthPackage
import SHNavigation
import CSRNetworkService

struct AuthenticationViewFactory {
    private let appSession: any AppSessionProtocol
    
    init(appSession: any AppSessionProtocol) {
        self.appSession = appSession
    }
    
    var authManager: FirebaseAuthenticator {
        FirebaseAuthenticator()
    }
    var networkService: NetworkService {
        NetworkService()
    }
    var userService: UserService {
        UserService(networkService: networkService)
    }
        
    @ViewBuilder
    func makeView(for destination: AppRootDestination) -> some View {
        switch destination {
        case .register:
            let viewModel = RegisterViewModel(
                authManager: authManager,
                userService: userService,
                appSession: appSession
            )
            RegisterView(viewModel: viewModel)
        case .login:
            LoginView(authManager: authManager)
        case .dashboard:
            DashboardView()
                .navigationBarBackButtonHidden(true)
        }
    }
}
