//
//  ShopProductDetailResponse.swift
//  BASICX SPORT
//
//  Created by Somesh K on 22/12/21.
//

import Foundation

// MARK: - DataClass

struct ShopProductDetailResponse: Codable {
    let merchandise: ShopProductDetailMerchandise
}

// MARK: - Merchandise

struct ShopProductDetailMerchandise: Codable {
    let id: Int
    let name: String
    let price: Float
    let itemDescription, identifier: String
    let inCart: Bool
    let category, brand: Brand
    let productImages: [ProductImage]
}

// MARK: - Brand

struct Brand: Codable {
    let id: Int
    let name: String
}

// MARK: - ProductImage

struct ProductImage: Codable, Hashable {
    let id: Int
    let productImageURL: String

    enum CodingKeys: String, CodingKey {
        case id
        case productImageURL = "productImageUrl"
    }
}
