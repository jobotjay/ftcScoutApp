//
//  MatchResults.swift
//  ftcScoutApp
//
//  Created by Jonas Jay on 9/29/26.
//

import Foundation

struct MatchResults: Codable {
    var matches: [MatchResult] = [MatchResult(actualStartTime: "", series: 0, matchNumber: 0, scoreRedFinal: 0, scoreRedFoul: 0, scoreRedAuto: 0, scoreBlueFinal: 0, scoreBlueFoul: 0, scoreBlueAuto: 0)]
}
