//
//  AddressListResponse.swift
//  BasicxSport
//
//  Created by Somesh K on 10/03/22.
//

import Foundation

// MARK: - AddressListResponse

struct AddressListResponse: Codable {
    let address: [Address]
}

// MARK: - Address

struct Address: Codable, Hashable {
    let id: Int
    let buildingName, streetAddress, landmark, addressType: String?
    let city, postalCode: String?
    let district, state, country: Country?
    let isPrimary: Bool
}

// MARK: - Country

struct Country: Codable, Hashable {
    let id: Int
    let name: String
}
