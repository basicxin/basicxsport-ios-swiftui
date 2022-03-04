//
//  SignInResponse.swift
//  BASICX SPORT
//
//  Created by Somesh K on 03/12/21.
//

import Foundation
import Networking

// MARK: - DataClass

struct SignInResponse: Codable {
    let member: Member
    let jwtToken: String
}

// MARK: - Member

struct Member: Codable {
    let id: Int
    let firstName, lastName, mobile, emailAddress: String
    let profilePictureURL: String
    let relationshipType: String
    let sport: Sport

    enum CodingKeys: String, CodingKey {
        case id, firstName, lastName, mobile, emailAddress
        case profilePictureURL = "profilePictureUrl"
        case relationshipType, sport
    }
}

// MARK: - Sport

struct Sport: Codable {
    let id: Int
    let name: String
    let sportIconURL: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case sportIconURL = "sportIconUrl"
    }
}
 
