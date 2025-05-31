//
//  RegisterViewModel.swift
//  ShroomHub
//
//  Created by Catalin Lucaciu on 24.05.2025.
//

import Foundation
import FirebaseAuthPackage

@Observable
final class RegisterViewModel {
    let authManager: FirebaseAuthenticating
    let userService: UserServiceProtocol
    let appSession: any AppSessionProtocol
    var email: String = ""
    var password: String = ""
    var name: String = ""
    var areFieldsCompleted: Bool {
        !(email.isEmpty || password.isEmpty || name.isEmpty)
    }
    private var avatarImageData: Data?
    
    init(
        authManager: FirebaseAuthenticating,
        userService: UserServiceProtocol,
        appSession: any AppSessionProtocol
    ) {
        self.authManager = authManager
        self.userService = userService
        self.appSession = appSession
    }
    

    func createUser() async throws {
        await MainActor.run {
            appSession.isUserCreationFinished = false
        }
        let loggedInUser = try await authManager.createUser(
            email: email,
            password: password
        )
        let userData = UserData(
            name: name,
            userID: loggedInUser.id,
            email: email,
            avatarImage: avatarImageData
        )
        try await userService.createUser(from: userData)
    }
        
    func setAvatarImageData(data: Data?) {
        self.avatarImageData = data
    }
}
