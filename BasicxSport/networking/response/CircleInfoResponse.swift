//
//  CircleInfoResponse.swift
//  BasicxSport
//
//  Created by Somesh K on 03/02/22.
//

import Foundation

struct CircleInfoResponse: Codable {
    let circle: CircleInfo
}

// MARK: - Circle

struct CircleInfo: Codable {
    let id: Int
    let name, about, emailAddress, phoneNumber: String
    let membercount: Int
    let checklistMessage, organizationName: String
    let organizationId: Int
    let checklists: [Checklist]
    let representatives: [Representative]
    let subscriptions: [Subscription]
    let circleRatings: CircleRatings
    let isJoined: Bool
}

// MARK: - Checklist

struct Checklist: Codable, Hashable {
    let id: Int
    let status, notes: String
    let joiningChecklist: JoiningChecklist
}

// MARK: - JoiningChecklist

struct JoiningChecklist: Codable, Hashable {
    let id: Int
    let length: Int?
    let joiningChecklistDescription: String
    let isMandatory: Bool
    let identityType: IdentityType

    enum CodingKeys: String, CodingKey {
        case id, length
        case joiningChecklistDescription = "description"
        case isMandatory, identityType
    }
}

// MARK: - IdentityType

struct IdentityType: Codable, Hashable {
    let id: Int
    let name, identityTypeDescription, identityIdRule: String
    let minChar, maxChar: Int
    let isNumeric: Bool

    enum CodingKeys: String, CodingKey {
        case id, name
        case identityTypeDescription = "description"
        case identityIdRule, minChar, maxChar, isNumeric
    }
}

// MARK: - CircleRatings

struct CircleRatings: Codable {
    let count5Star, count4Star, count3Star, count2Star: Int
    let count1Star: Int
    let averageRating: Double
    let totalCount: Int
    let memberReview: MemberReview?
}

// MARK: - MemberReview

struct MemberReview: Codable {
    let id, rating: Int
    let comment: String
    let createdOn: Int
}

// MARK: - Representative

struct Representative: Codable, Hashable {
    let id: Int
    let position, mobile, name: String
    let profilePictureUrl: String
}

// MARK: - Subscription

struct Subscription: Codable, Hashable {
    let id: Int
    let subscriptionDescription: String
    let price: Int
    let name: String
    let noOfDays: Int

    enum CodingKeys: String, CodingKey {
        case id
        case subscriptionDescription = "description"
        case price, name, noOfDays
    }
}
