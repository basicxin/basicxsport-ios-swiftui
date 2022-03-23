//
//  MyWallResponse.swift
//  BasicxSport
//
//  Created by Somesh K on 22/03/22.
//

import Foundation

// MARK: - MyWallResponse

struct MyWallResponse: Codable {
    let stats: [WallStats]
    let certificates: [Certificate]
    let memberSportClub: MemberSportClub
}

// MARK: - MemberSportClub

struct MemberSportClub: Codable, Hashable {
    let id: Int?
    let clubName: String
    let sport: Sport?
}

// MARK: - WallStats

struct WallStats: Codable, Hashable {
    let count: Int
    let name: String
}

// MARK: - Certificate

struct Certificate: Codable, Hashable {
    let id: Int
    let name: String
    let certifcateUrl: String
}
