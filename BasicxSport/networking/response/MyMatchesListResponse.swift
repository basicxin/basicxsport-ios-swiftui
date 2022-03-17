//
//  MyMatchesListResponse.swift
//  BasicxSport
//
//  Created by Somesh K on 17/03/22.
//

import Foundation

// MARK: - MyMatchesListResponse

struct MyMatchesListResponse: Codable {
    let matches: [Match]
}

// MARK: - Match

struct Match: Codable , Hashable{
    let id, startTime: Int
    let matchName: String
    let endTime: Int
    let status, matchType: String
    let isBye: Bool
    let winner: MyMatchesWinner?
    let team1, team2: MyMatchesTeam
    let sets: [MyMatchesSet]
}

// MARK: - Set

struct MyMatchesSet: Codable  , Hashable{
    let id, setNo, playerAScore, playerBScore: Int
    let winner: String
}

// MARK: - Set

struct MyMatchesWinner: Codable , Hashable {
    let winnerId: Int
}

// MARK: - Team

struct MyMatchesTeam: Codable , Hashable {
    let id: Int
    let name, seatType: String
    let teamLogoUrl: String
    let players: [MyMatchesPlayer]
}

// MARK: - Player

struct MyMatchesPlayer: Codable , Hashable {
    let id: Int
    let name: String
    let profilePictureUrl: String
}
