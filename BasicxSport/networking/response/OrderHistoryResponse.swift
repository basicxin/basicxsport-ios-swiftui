//
//  OrderHistoryResponse.swift
//  BasicxSport
//
//  Created by Somesh K on 02/03/22.
//

import Foundation

// MARK: - DataClass

struct OrderHistoryResponse: Codable {
    let orders: [Order]
}

// MARK: - Order

struct Order: Codable, Hashable {
    let id: Int
    let invoiceNo: String
    let totalAmount: Double
    let status: String?
    let dateOfSale, discount, subTotal: Int
    let otherCharges, tax: Double
    let circle: CircleOrderHistory
    let itemList: [ItemList]
}

// MARK: - Circle

struct CircleOrderHistory: Codable, Hashable {
    let id: Int
    let name: String
    let logoUrl: String
}

// MARK: - ItemList

struct ItemList: Codable, Hashable {
    let id, amount, quantity: Int
    let product, subscription, tournamentCategory: ProductOrderHistory?
}

// MARK: - Product

struct ProductOrderHistory: Codable, Hashable {
    let id: Int
    let name, productDescription: String

    enum CodingKeys: String, CodingKey {
        case id, name
        case productDescription = "description"
    }
}
