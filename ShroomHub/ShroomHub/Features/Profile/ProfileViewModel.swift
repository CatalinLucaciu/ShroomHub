//
//  ProfileViewModel.swift
//  ShroomHub
//
//  Created by Catalin Lucaciu on 08.06.2025.
//

import Foundation
import FirebaseAuthPackage


@Observable
final class ProfileViewModel {
    private let userService: UserServiceProtocol
    private let fireBaseAuthenticator: FirebaseAuthenticating
    
    init(userService: UserServiceProtocol,
         fireBaseAuthenticator: FirebaseAuthenticating) {
        self.userService = userService
        self.fireBaseAuthenticator = fireBaseAuthenticator
    }
    
    func getUserDetails() async throws -> FireBaseUser {
        let currentUser = fireBaseAuthenticator.currentUser
        guard let userId = currentUser?.id else {
            throw UserError.couldNotFindUser
        }
        return try await userService.getUserDetails(from: userId)
    }
    
    func signOut() async throws {
       try await fireBaseAuthenticator.signOut()
    }
}
