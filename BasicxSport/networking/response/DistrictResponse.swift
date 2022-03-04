//
//  DistrictResponse.swift
//  BasicxSportSwiftUI
//
//  Created by Somesh K on 13/01/22.
//

// MARK: - DataClass

struct DistrictResponse: Codable {
    let districts: [District]
}

// MARK: - District

struct District: Codable {
    let id: Int
    let name: String
}
