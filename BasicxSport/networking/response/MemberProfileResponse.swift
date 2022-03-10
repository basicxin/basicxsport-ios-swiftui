//
//  MemberProfileResponse.swift
//  BasicxSport
//
//  Created by Somesh K on 08/03/22.
//

import Foundation

// MARK: - MemberProfileResponse

struct MemberProfileResponse: Codable {
    let member: MemberProfile
}

// MARK: - Member

struct MemberProfile: Codable {
    let id: Int
    let title, firstName, lastName, gender: String
    let dob, mobile, emailAddress: String
    let profilePictureUrl: String
    let relationshipType: String
    let isMobileNoVerified, isEmailAddressVerified: Bool
}
