//
//  FireBaseUser.swift
//  ShroomHub
//
//  Created by Catalin Lucaciu on 24.05.2025.
//

import FirebaseFirestore

struct FireBaseUser: Codable, Hashable {
    @DocumentID var id: String?
    let name: String
    let email: String
    let avatarURL: String?
}
