//
//  SharingContainer.swift
//  ftcScoutApp
//
//  Created by Jonas Jay on 10/26/26.
//

import Foundation

struct SharingContainer: Codable {
    let questions: [Question]
    let answers: [Answer]
    let teamNotes: [TeamNotes]
}

struct ChunkContainer: Codable {
    let num: Int
    let total: Int
    let chunk: Data
}
