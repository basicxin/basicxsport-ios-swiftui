//
//  ShopResponse.swift
//  BASICX SPORT
//
//  Created by Somesh K on 09/12/21.
//

import Foundation

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let shopResponse = try? newJSONDecoder().decode(ShopResponse.self, from: jsonData)

import Foundation

// MARK: - ShopDataClass

struct ShopResponse: Codable {
    let merchandise: [Merchandise]
    let pageCount, itemCount, cartCount: Int
}

// MARK: - Merchandise

struct Merchandise: Codable, Hashable {
    let id: Int
    let name: String
    let price: Float
    let itemPictureURL: String

    enum CodingKeys: String, CodingKey {
        case id, name, price
        case itemPictureURL = "itemPictureUrl"
    }
}
