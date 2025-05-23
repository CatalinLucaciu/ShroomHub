//
//  CloudinaryUploadResponse.swift
//  ShroomHub
//
//  Created by Catalin Lucaciu on 10.05.2025.
//


import Foundation

public struct CloudinaryUploadResponse: Decodable {
    public let secureURL: URL

    enum CodingKeys: String, CodingKey {
        case secureURL = "secure_url"
    }
}