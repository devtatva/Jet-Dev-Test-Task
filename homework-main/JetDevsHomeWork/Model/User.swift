//
//  User.swift
//  JetDevsHomeWork
//
//  Created by pcq186 on 12/12/22.
//

import Foundation

struct User: Codable {
    
    let userId: Int?
    let username: String?
    let userProfileUrl: String?
    let createdAt: String?

    enum CodingKeys: String, CodingKey {

        case userId = "user_id"
        case username = "user_name"
        case userProfileUrl = "user_profile_url"
        case createdAt = "created_at"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        userId = try values.decodeIfPresent(Int.self, forKey: .userId)
        username = try values.decodeIfPresent(String.self, forKey: .username)
        userProfileUrl = try values.decodeIfPresent(String.self, forKey: .userProfileUrl)
        createdAt = try values.decodeIfPresent(String.self, forKey: .createdAt)
    }

}
