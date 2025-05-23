//
//  MushroomError.swift
//  ShroomHub
//
//  Created by Catalin Lucaciu on 22.05.2025.
//

import Foundation

enum MushroomError: LocalizedError, Error {
    case userNotLoggedIn
    case photoUploadingError
    
    var errorDescription: String {
        switch self {
        case .userNotLoggedIn:
            return "User is not logged in. Please log in to continue."
        case .photoUploadingError:
            return "There was a problem uploading the photo. Please try again later."
        }
    }
}
