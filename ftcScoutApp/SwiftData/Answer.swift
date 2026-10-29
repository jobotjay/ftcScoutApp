//
//  Answer.swift
//  ftcScoutApp
//
//  Created by Jonas Jay on 10/2/26.
//

import Foundation
import SwiftData

@Model
class Answer: Codable {
    var teamNumber: Int
    var answers: [String]
    
    init(teamNumber: Int, answers: [String]) {
        self.teamNumber = teamNumber
        self.answers = answers
    }
    
    enum CodingKeys: CodingKey {
        case teamNumber, answers
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.teamNumber = try container.decode(Int.self, forKey: .teamNumber)
        self.answers = try container.decode([String].self, forKey: .answers)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(teamNumber, forKey: .teamNumber)
        try container.encode(answers, forKey: .answers)
    }
}
