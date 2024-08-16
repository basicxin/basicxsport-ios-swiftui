//
//  CartResponseResponse.swift
//  BASICX SPORT
//
//  Created by Somesh K on 29/12/21.
//

import Foundation

// MARK: - DataClass

struct CartResponse: Codable {
    let cart: Cart
}

// MARK: - Cart

struct Cart: Codable, Hashable {
    let id: Int
    let orderNo, promoCode: String
    let discount: Int
    let otherCharges, tax: Double
    let roundOff: Int?
    let totalItems: Int
    let totalAmount,subTotal: Float
    let items: [CartItem]
}

// MARK: - CartItem

struct CartItem: Codable, Hashable {
    let id: Int
    let name: String
    var itemID, quantity: Int
    let itemDescription: String
    let pictureURL: String
    let itemType: String
    let price: Float

    enum CodingKeys: String, CodingKey {
        case id, name
        case itemID = "itemId"
        case quantity, price
        case itemDescription = "description"
        case pictureURL = "pictureUrl"
        case itemType
    }
}
