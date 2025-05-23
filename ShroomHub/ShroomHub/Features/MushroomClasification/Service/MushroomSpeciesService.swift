//
//  MushroomSpeciesService.swift
//  ShroomHub
//
//  Created by Catalin Lucaciu on 24.04.2025.
//

import FirebaseFirestore
import Firebase
import Foundation
import CSRNetworkService
import CSRLocationService

private enum Constants {
    static let speciesCollectionName = "mushrooms"
    static let findingsCollectionName = "mushroomFindings"
    static let userSavedFindingsCollectionName = "userSavedFindings"
    static let postFeedCollectionName = "mushroomFeedPosts"
    static let cloudinaryUploadPreset = "unsigned_mushroom_upload"
    static let cloudinaryName = "dwekgpkjx"
}

private enum SavedFindingsDbConstants {
    static let userIDFieldName = "userId"
}

private enum PostFeedCollectioConstants {
    static let userIDFieldName = "userId"
    static let timeStampFieldName = "timestamp"
}

protocol MushroomServiceProtocol {
    func fetchSpecies(classificationName: String) async throws -> MushroomSpecies
    /// Uploads a mushroom photo to Cloudinary and returns the secure public URL of the uploaded image.
    ///
    /// The image will be stored in a folder structure based on the user's ID (e.g., `userID/mushrooms`)
    /// using an unsigned upload preset configured in Cloudinary.
    ///
    /// - Parameters:
    ///   - imageData: The raw JPEG data of the image to be uploaded.
    ///   - userID: The ID of the user, used to organize the image in Cloudinary under a specific folder.
    /// - Returns: The secure `URL` pointing to the uploaded image hosted on Cloudinary.
    /// - Throws: `NetworkError` if the upload fails or the response cannot be decoded.
    func uploadMushroomPhoto(
        with imageData: Data,
        userID: String
    ) async throws -> URL
    func saveToCollection(_ finding: MushroomFinding) async throws
    func postMushroom(
        _ finding: MushroomFinding,
        message: String
    ) async throws
    func getMushroomCollection(for userId: String) async throws -> [CollectedMushroom]
    func getFeed(except userId: String) async throws -> [HomeFeedPost]
}

final class MushroomSpeciesService: MushroomServiceProtocol {
    private let db = Firestore.firestore()
    private let networkService: NetworkServiceProtocol
    private let locationProvider: LocationProviding
    
    init(
        networkService: NetworkServiceProtocol,
        locationProvder: LocationProviding) {
        self.networkService = networkService
        self.locationProvider = locationProvder
    }
    
    func uploadMushroomPhoto(
        with imageData: Data,
        userID: String
    ) async throws -> URL {
        try await networkService.send(
            UploadMushroomImageRequest.init(
                imageData: imageData,
                userID: userID,
                uploadPreset: Constants.cloudinaryUploadPreset,
                cloudName: Constants.cloudinaryName
            )).secureURL
    }
    
    func fetchSpecies(classificationName: String) async throws -> MushroomSpecies {
        let documentReference = db.collection(Constants.speciesCollectionName).document(classificationName)
        return try await documentReference.getDocument(as: MushroomSpecies.self)
    }
}

// MARK: - Feed
extension MushroomSpeciesService {
    func postMushroom(_ finding: MushroomFinding, message: String) async throws {
        guard let findingId = finding.id else { return }
        let findingRefrence = db
            .collection(Constants.findingsCollectionName)
            .document(findingId)
        let feedPost = MushroomFeedPost(
            findingReference: findingRefrence,
            userId: finding.userId,
            message: message,
            likeCount: 0,
            commentCount: 0,
            timestamp: Int(Date().timeIntervalSince1970)
        )
        try await uploadFindingIfNecessary(finding)
        try db
            .collection(Constants.postFeedCollectionName)
            .addDocument(from: feedPost)
    }
    
    func getFeed(except userId: String) async throws -> [HomeFeedPost] {
        let snapShot = try await db
            .collection(Constants.postFeedCollectionName)
            .whereFilter(.whereField(PostFeedCollectioConstants.userIDFieldName, isNotEqualTo: userId))
            .order(by: PostFeedCollectioConstants.timeStampFieldName, descending: true)
            .getDocuments()
        let feedPosts = try snapShot.documents.map {
            try $0.data(as: MushroomFeedPost.self)
        }
        return try await mapHomeFeedPosts(from: feedPosts)
    }

}

// MARK: - Save Post
extension MushroomSpeciesService {
    func saveToCollection(_ finding: MushroomFinding) async throws {
        guard let findingId = finding.id else { return }
        let findingRefrence = db
            .collection(Constants.findingsCollectionName)
            .document(findingId)
        let userSavedPost = MushroomSavedPost(
            userId: finding.userId,
            findingReference: findingRefrence
        )
        try await uploadFindingIfNecessary(finding)
        try db
            .collection(Constants.userSavedFindingsCollectionName)
            .addDocument(from: userSavedPost)
    }
    
    func getMushroomCollection(for userId: String) async throws ->  [CollectedMushroom] {
        let snapShot = try await db
            .collection(Constants.userSavedFindingsCollectionName)
            .whereField(
                SavedFindingsDbConstants.userIDFieldName,
                isEqualTo: userId
            )
            .getDocuments()
        let savedPosts = try snapShot.documents.map {
            try $0.data(as: MushroomSavedPost.self)
        }
        let findingsDocuments = savedPosts.map {
            $0.findingReference
        }
        let findings: [MushroomFinding] = try await getItemsFromReferences(from: findingsDocuments)
        return try await mapCollectedMushrooms(from: findings)
    }
}

// MARK: - Utils
private extension MushroomSpeciesService {
    func uploadFindingIfNecessary(_ finding: MushroomFinding) async throws {
        guard let findingId = finding.id else { return }
        let findingRef = db.collection(Constants.findingsCollectionName).document(findingId)
        let snapShot = try await findingRef.getDocument()
        if !snapShot.exists {
            try findingRef.setData(from: finding)
        }
    }
    
    func getItemsFromReferences<T: Decodable>(from references: [DocumentReference]) async throws -> [T] {
            try await withThrowingTaskGroup(of: T.self) { group in
                for reference in references {
                    group.addTask {
                        try await reference.getDocument(as: T.self)
                    }
                }
                return try await group.reduce(into: [T]()) { $0.append($1) }
            }
    }
    
    func fetchSpeciesAndLocation(from finding: MushroomFinding) async throws -> (MushroomSpecies, ReverseGeocodedLocation?) {
        async let fetchSpecies = try await finding
            .speciesReference
            .getDocument(as: MushroomSpecies.self)
        async let fetchLocation = await self.locationProvider.reverseGeoCode(
            latitude: finding.location.latitude,
            longitude: finding.location.longitude
        )
        return try await (fetchSpecies, fetchLocation)
    }

    func mapCollectedMushrooms(from findings: [MushroomFinding]) async throws -> [CollectedMushroom] {
        try await withThrowingTaskGroup(of: CollectedMushroom.self) { group in
            for finding in findings {
                group.addTask {
                    let (species, location) = try await self.fetchSpeciesAndLocation(from: finding)
                    return CollectedMushroom(
                        record: finding,
                        species: species,
                        location: location?.address,
                        locationURL: location?.mapsURL)
                }
            }
            return try await group.reduce(into: []) { $0.append($1) }
        }
    }
    
    func mapHomeFeedPosts(from fireBasePosts: [MushroomFeedPost]) async throws -> [HomeFeedPost] {
        try await withThrowingTaskGroup(of: HomeFeedPost.self) { group in
            for fireBasePost in fireBasePosts {
                group.addTask {
                    let finding = try await fireBasePost
                        .findingReference
                        .getDocument(as: MushroomFinding.self)
                    let (species, location) = try await self.fetchSpeciesAndLocation(from: finding)
                    return HomeFeedPost(
                        finding: finding,
                        postDetails: fireBasePost,
                        speciesDetails: species,
                        location: location?.address,
                        locationURL: location?.mapsURL
                    )
                }
            }
            return try await group.reduce(into: [], { $0.append($1) })
        }
    }
}


