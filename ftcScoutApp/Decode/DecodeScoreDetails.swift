//
//  ScoreDetails.swift
//  ftcScoutApp
//
//  Created by Jonas Jay on 9/28/26.
//

import Foundation

struct DecodeScoreDetails: Codable, Hashable, ScoreDetails {
    let matchScores: [DecodeMatchScores]
}
