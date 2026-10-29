//
//  Question.swift
//  ftcScoutApp
//
//  Created by Jonas Jay on 10/2/26.
//

import Foundation
import SwiftData

@Model
class Question: Codable {
    var index: Int
    var question: String
    var order: Int
    
    init(index: Int, question: String, order: Int) {
        self.index = index
        self.question = question
        self.order = order
    }
    
    enum CodingKeys: CodingKey {
        case index, question, order
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.index = try container.decode(Int.self, forKey: .index)
        self.question = try container.decode(String.self, forKey: .question)
        self.order = try container.decode(Int.self, forKey: .order)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(index, forKey: .index)
        try container.encode(question, forKey: .question)
        try container.encode(order, forKey: .order)
    }
}
