//
//  TournamentListResponse.swift
//  BasicxSport
//
//  Created by Somesh K on 14/03/22.
//

import Foundation

// MARK: - TournamentListResponse

struct TournamentListResponse: Codable {
    let tournaments: [Tournament]
}

// MARK: - Tournament

struct Tournament: Codable, Hashable {
    let id: Int
    let name: String
    let startTime, endTime: Int64
    let status: String
    let bannerUrl: String
    let sport: Sport
    let locations: [Location]?
}

// MARK: - Location

struct Location: Codable, Hashable, Identifiable {
    let id: Int
    let name: String
    let latitude: Double
    let longitude: Double
}
