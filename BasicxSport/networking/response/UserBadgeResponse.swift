//
//  UserBadgeResponse.swift
//  BasicxSport
//
//  Created by Somesh K on 12/02/22.
//

import Foundation

// MARK: - DataClass

struct UserBadgeResponse: Codable {
    let member: BadgeMember
}

// MARK: - Member

struct BadgeMember: Codable {
    let id: Int
    let firstName, lastName, gender: String
    let dob: String
    let qrCodeUrl: String
    let memberRegistrationId: String
    let profilePictureUrl: String
    let district: District

    enum CodingKeys: String, CodingKey {
        case id, firstName, lastName, gender, dob, qrCodeUrl
        case memberRegistrationId = "memberRegistrationID"
        case profilePictureUrl, district
    }
}
