//
//  BiobuzzMatchScores.swift
//  ftcScoutApp
//
//  Created by Jonas Jay on 10/14/26.
//

import Foundation

struct BiobuzzMatchScores: Codable, Hashable {
    let matchLevel: String
    let matchSeries: Int
    let matchNumber: Int
    let randomization: Int
    let alliances: [BiobuzzAlliance]
}
