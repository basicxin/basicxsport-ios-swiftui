//
//  TournamentRulesResponse.swift
//  BasicxSport
//
//  Created by Somesh K on 23/03/22.
//

import Foundation

// MARK: - TournamentRulesResponse

struct TournamentRulesResponse: Codable {
    let sportRules: SportRules
}

// MARK: - SportRules

struct SportRules: Codable {
    let id: Int
    let name, rulesContent: String
}
