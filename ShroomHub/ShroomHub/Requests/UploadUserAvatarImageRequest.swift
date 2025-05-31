//
//  UploadUserAvatarImageRequest.swift
//  ShroomHub
//
//  Created by Catalin Lucaciu on 24.05.2025.
//

import Foundation
import Alamofire
import CSRNetworkService

public struct UploadUserAvatarImageRequest: RequestDescriptor {
    public typealias ResponseType = CloudinaryUploadResponse

    public let imageData: Data
    public let userID: String
    public let uploadPreset: String
    public let cloudName: String

    public var baseURL: URL {
        URL(string: "https://api.cloudinary.com/v1_1/\(cloudName)/image/upload")!
    }

    public var fileName: String {
        "avatar.jpg"
    }

    public var path: String { "" }
    public var method: HTTPMethod = .post
    public var headers: HTTPHeaders? = nil
    public var queryParameters: [String: String]? = nil
    public var bodyParameters: Parameters? = nil

    public var multipartFormData: [MultipartFormField]? {
        [
            .init(name: "upload_preset", type: .text(uploadPreset)),
            .init(name: "folder", type: .text("userAvatars/\(userID)")),
            .init(name: "public_id", type: .text("userAvatars/\(userID)/avatar")),
            .init(name: "file", type: .file(data: imageData, fileName: fileName, mimeType: "image/jpeg"))
        ]
    }

    public var contentType: ContentType = .multipart

    public func decode(_ data: Data) throws -> CloudinaryUploadResponse {
        try JSONDecoder().decode(CloudinaryUploadResponse.self, from: data)
    }
}
