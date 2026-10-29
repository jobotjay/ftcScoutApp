//
//  BiobuzzScoreDetails.swift
//  ftcScoutApp
//
//  Created by Jonas Jay on 10/15/26.
//

import Foundation

struct BiobuzzScoreDetails: Codable, Hashable, ScoreDetails {
    let matchScores: [BiobuzzMatchScores]
}
