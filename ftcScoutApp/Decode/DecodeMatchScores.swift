//
//  MatchScores.swift
//  ftcScoutApp
//
//  Created by Jonas Jay on 9/28/26.
//

import Foundation

struct DecodeMatchScores: Codable, Hashable {
    let matchLevel: String
    let matchSeries: Int
    let matchNumber: Int
    let randomization: Int
    let alliances: [DecodeAlliance]
}
