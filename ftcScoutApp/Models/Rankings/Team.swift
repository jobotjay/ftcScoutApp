//
//  Team.swift
//  ftcScoutApp
//
//  Created by Jonas Jay on 9/22/26.
//

import Foundation
import SwiftData

struct Team: Codable, Identifiable {
    internal let id = UUID()
    var rank: Int = 1
    var teamNumber: Int = 12345
    var displayTeamNumber: String = "12345"
    var teamName: String = "Team Team"
    var sortOrder1: Double = 0.0
    var sortOrder2: Double = 0.0
    var sortOrder3: Double = 0.0
    var sortOrder4: Double = 0.0
    var sortOrder5: Double = 0.0
    var sortOrder6: Double = 0.0
    var wins: Int = 0
    var losses: Int = 0
    var ties: Int = 0
    var qualAverage: Double = 0.0
    var dq: Int = 0
    var matchesPlayed: Int = 0
    var matchesCounted: Int = 0
}
