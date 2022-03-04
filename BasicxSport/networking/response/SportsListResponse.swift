//
//  SportsListResponse.swift
//  BASICX SPORT
//
//  Created by Somesh K on 13/12/21.
//

import Foundation

// MARK: - SportsListDataClass

struct SportsListResponse: Codable {
    let sports: [SportsListSport]
}

// MARK: - Sport

struct SportsListSport: Codable, Hashable {
    let id: Int
    let name: String
    let sportIconURL: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case sportIconURL = "sportIconUrl"
    }
}
