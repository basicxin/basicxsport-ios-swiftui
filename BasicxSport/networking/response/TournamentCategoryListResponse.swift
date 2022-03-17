//
//  TournamentCategoryListResponse.swift
//  BasicxSport
//
//  Created by Somesh K on 14/03/22.
//

import Foundation

// MARK: - TournamentCategoryListResponse

struct TournamentCategoryListResponse: Codable {
    let categories: [TournamentCategory]
}

// MARK: - Category

struct TournamentCategory: Codable , Hashable {
    let id: Int
    let name, categoryDescription: String
    let price: Int
    let status, seatType, matchFormat: String
    let isEligible, isEnrolled: Bool

    enum CodingKeys: String, CodingKey {
        case id, name
        case categoryDescription = "description"
        case price, status, seatType, matchFormat, isEligible, isEnrolled
    }
}
