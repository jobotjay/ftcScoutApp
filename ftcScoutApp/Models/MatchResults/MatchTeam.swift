//
//  MatchTeam.swift
//  ftcScoutApp
//
//  Created by Jonas Jay on 9/29/26.
//

import Foundation

struct MatchTeam: Codable, Identifiable {
    internal let id = UUID()
    var teamNumber: Int
    var station: String?
    var dq: Bool
    var onField: Bool
}
