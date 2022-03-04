//
//  SearchCircleResponse.swift
//  BASICX SPORT
//
//  Created by Somesh K on 13/12/21.
//

import Foundation

// MARK: - DataClass

struct SearchCircleResponse: Codable {
    let circles: [SearchedCircles]
}

// MARK: - Circle

struct SearchedCircles: Codable, Hashable {
    let id: Int
    let name: String
    let logoURL: String
    let baseColor: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case logoURL = "logoUrl"
        case baseColor
    }
}
