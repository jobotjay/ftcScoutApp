//
//  AppStateManager.swift
//  ftcScoutApp
//
//  Created by Jonas Jay on 9/23/26.
//

import Foundation
import SwiftData

@Model
class TeamNotes: Codable {
    var team: Int
    var notes: String
    
    init(team: Int, notes: String) {
        self.team = team
        self.notes = notes
    }
    
    enum CodingKeys: CodingKey {
        case team, notes
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.team = try container.decode(Int.self, forKey: .team)
        self.notes = try container.decode(String.self, forKey: .notes)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(team, forKey: .team)
        try container.encode(notes, forKey: .notes)
    }
}
