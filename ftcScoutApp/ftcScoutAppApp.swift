//
//  ftcScoutAppApp.swift
//  ftcScoutApp
//
//  Created by Jonas Jay on 9/22/26.
//

import SwiftUI
import SwiftData

@main
struct ftcScoutAppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [TeamNotes.self, Question.self, Answer.self, EventCode.self])
    }
}
