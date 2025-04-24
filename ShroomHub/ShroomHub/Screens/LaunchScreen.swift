//
//  LaunchScreen.swift
//  ShroomHub
//
//  Created by Catalin Lucaciu on 02.03.2025.
//

import SwiftUI
import ShroomHubDesignLibrary
import FirebaseAuthPackage
import SHNavigation

private enum Constants {
    static let logoSize: CGFloat = 150
}

struct LaunchScreen: View {
    @EnvironmentObject private var router: NavigationRouter
    private let authenticationViewFactory: AuthenticationViewFactory
    
    init(authenticationViewFactory: AuthenticationViewFactory) {
        self.authenticationViewFactory = authenticationViewFactory
    }
    
    var body: some View {
        NavigationStack(path: $router.rootPath) {
            VStack(spacing: Spacing.medium) {
                Image("appLogo")
                    .resizable()
                    .frame(width: 150, height: 150)
                    .foregroundStyle(SHColor.forestGreen)
                
                Text(header)
                    .font(.bold30)
                
                Text(subHeader)
                    .font(.regular14)
                
                Spacer()
                
                buttonsView
                    .padding(.bottom, Spacing.medium)
            }
            .navigationDestination(for: NavigationRouter.Destination.self) { destination in
                authenticationViewFactory.makeView(for: destination)
            }
        }
    }
}

#Preview {
    LaunchScreen(authenticationViewFactory: AuthenticationViewFactory(authManager: FirebaseAuthenticator()))
}

// MARK: - Views
private extension LaunchScreen {
    @ViewBuilder
    var buttonsView: some View {
        VStack(spacing: Spacing.small) {
            Button(registerButtonText) {
                router.navigate(to: .register)
            }
            .buttonStyle(SHMainButtonStyle(style: .primary))
            
            Button(loginButtonText) {
                router.navigate(to: .login)
            }
            .buttonStyle(SHMainButtonStyle(style: .secondary))
        }
        .padding(.horizontal, Spacing.medium)
    }
}

// MARK: - Strings
private extension LaunchScreen {
    var header: String {
        "Let's Get Started"
    }
    
    var subHeader: String {
        "Let's dive into your account"
    }
    
    var registerButtonText: String {
        "Sign Up"
    }
    
    var loginButtonText: String {
        "Log in"
    }
}
