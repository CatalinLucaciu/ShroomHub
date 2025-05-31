//
//  UserService.swift
//  ShroomHub
//
//  Created by Catalin Lucaciu on 24.05.2025.
//

import Foundation
import CSRNetworkService
import FirebaseFirestore

private enum Constants {
    static let collectionName = "users"
    static let cloudinaryUploadPreset = "unsigned_avatar_upload"
    static let cloudinaryName = "dwekgpkjx"
}

protocol UserServiceProtocol {
    func createUser(from userData: UserData) async throws
    func getUserDetails(from userId: String) async throws -> FireBaseUser
}

@Observable
final class UserService: UserServiceProtocol {
    private let db = Firestore.firestore()
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func createUser(from userData: UserData) async throws {
        let userReference = db
            .collection(Constants.collectionName)
            .document(userData.userID)
        let snapShot = try await userReference.getDocument()
        if !snapShot.exists {
            let fireBaseUser = try await createFirebaseUserDocument(from: userData)
            try userReference.setData(from: fireBaseUser)
        }
    }
    
    func getUserDetails(from userId: String) async throws -> FireBaseUser {
        return try await db
            .collection(Constants.collectionName)
            .document(userId)
            .getDocument(as: FireBaseUser.self)
    }
}

private extension UserService {
    func createFirebaseUserDocument(from userData: UserData) async throws -> FireBaseUser {
        var imageUrl: URL?
        if let imageData = userData.avatarImage {
            imageUrl = try await uploadAvatarImage(
                with: imageData,
                userID: userData.userID)
        }
        return FireBaseUser(
            id: userData.userID,
            name: userData.name,
            email: userData.email,
            avatarURL: imageUrl?.absoluteString
        )
    }
    
    func uploadAvatarImage(
        with imageData: Data,
        userID: String
    ) async throws -> URL {
        try await networkService.send(
            UploadUserAvatarImageRequest.init(
                imageData: imageData,
                userID: userID,
                uploadPreset: Constants.cloudinaryUploadPreset,
                cloudName: Constants.cloudinaryName
            )).secureURL
    }
}
