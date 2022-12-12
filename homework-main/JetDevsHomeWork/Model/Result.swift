//
//  Result.swift
//  JetDevsHomeWork
//
//  Created by pcq186 on 12/12/22.
//

import Foundation

struct Result: Codable {
    
    let result: Int?
    let errorMessage: String?
    let data: UserData?

    enum CodingKeys: String, CodingKey {

        case result = "result"
        case errorMessage = "error_message"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        result = try values.decodeIfPresent(Int.self, forKey: .result)
        errorMessage = try values.decodeIfPresent(String.self, forKey: .errorMessage)
        data = try values.decodeIfPresent(UserData.self, forKey: .data)
    }
}

struct UserData: Codable {
    
    let user: User?

    enum CodingKeys: String, CodingKey {

        case user = "user"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        user = try values.decodeIfPresent(User.self, forKey: .user)
    }
}
