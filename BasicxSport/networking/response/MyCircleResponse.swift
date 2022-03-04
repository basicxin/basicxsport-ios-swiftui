//
//  MyCircleResponse.swift
//  BASICX SPORT
//
//  Created by Somesh K on 20/12/21.
//
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let myCircleResponse = try? newJSONDecoder().decode(MyCircleResponse.self, from: jsonData)

import Foundation

// MARK: - DataClass

struct MyCircleResponse: Codable {
    var circles: [Circle]
    let preferredCircle: PreferredCircle
    let providers: [Circle]
    let relations: [Relation]
}

// MARK: - Circle

struct Circle: Codable, Hashable {
    let id: Int
    let name: String
    let circleDescription: String?
    let logoURL: String
    let baseColor: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case circleDescription = "description"
        case logoURL = "logoUrl"
        case baseColor
    }
}

// MARK: - PreferredCircle

struct PreferredCircle: Codable {
    let id: Int?
    let name: String
    let logoURL: String
    let baseColor: String
    let membersCount: Int?
    let joinedDate: Int64?
    let organizationName: String
    let expiryDate: Int?
    let circleMemberData: CircleMemberData
    let circleType: CircleType?

    enum CodingKeys: String, CodingKey {
        case id, name
        case logoURL = "logoUrl"
        case baseColor, membersCount, joinedDate, organizationName, expiryDate, circleMemberData, circleType
    }
}

// MARK: - CircleMemberData

struct CircleMemberData: Codable {
    let id: Int?
    let subscriptionStatus: String
}

// MARK: - CircleType

struct CircleType: Codable {
    let id: Int
    let type: String
}

// MARK: - Relation

struct Relation: Codable, Hashable {
    let id: Int
    let title, firstName, lastName, gender: String
    let mobile, dob, emailAddress: String
    let profilePictureURL: String
    let relationshipType: String
    let circle: Circle?
    let isMobilNoVerified: Bool?
    let isEmailAddressVerified: Bool
    let sport: MyCircleSport
    let isMobileNoVerified: Bool?

    enum CodingKeys: String, CodingKey {
        case id, title, firstName, lastName, gender, mobile, dob, emailAddress
        case profilePictureURL = "profilePictureUrl"
        case relationshipType, circle, isMobilNoVerified, isEmailAddressVerified, sport, isMobileNoVerified
    }
}

// MARK: - Sport

struct MyCircleSport: Codable, Hashable {
    let id: Int?
    let name: String?
    let sportIconURL: String?
    let sportID: Int?
    let sportName, sportSportIconURL: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case sportIconURL = "sportIconUrl"
        case sportID = "id "
        case sportName = "name "
        case sportSportIconURL = "sportIconUrl "
    }
}
