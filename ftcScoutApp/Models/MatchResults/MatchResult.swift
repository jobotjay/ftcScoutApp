//
//  MatchResult.swift
//  ftcScoutApp
//
//  Created by Jonas Jay on 9/29/26.
//

import Foundation

struct MatchResult: Codable, Identifiable {
    internal let id = UUID()
    var actualStartTime: String?
    var description: String?
    var tournamentLevel: String?
    var series: Int
    var matchNumber: Int
    var scoreRedFinal: Int
    var scoreRedFoul: Int
    var scoreRedAuto: Int
    var scoreBlueFinal: Int
    var scoreBlueFoul: Int
    var scoreBlueAuto: Int
    var postResultTime: String?
    var videoURL: String?
    var modifiedOn: String?
    var teams: [MatchTeam] = []
}
