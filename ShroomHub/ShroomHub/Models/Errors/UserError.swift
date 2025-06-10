//
//  UserError.swift
//  ShroomHub
//
//  Created by Catalin Lucaciu on 08.06.2025.
//

import Foundation

enum UserError: LocalizedError, Error {
    case couldNotFindUser
    
    var errorDescription: String {
        switch self {
        case .couldNotFindUser:
            return "Could not find the user, please try again"
        }
    }
}
