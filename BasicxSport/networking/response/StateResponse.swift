//
//  StateResponse.swift
//  BasicxSportSwiftUI
//
//  Created by Somesh K on 13/01/22.
//

// MARK: - DataClass

struct StateResponse: Codable {
    let states: [Country]
}

// MARK: - District

struct States: Codable {
    let id: Int
    let name: String
}
