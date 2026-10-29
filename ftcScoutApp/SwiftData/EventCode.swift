//
//  EventCode.swift
//  ftcScoutApp
//
//  Created by Jonas Jay on 10/12/26.
//

import Foundation
import SwiftData

@Model
class EventCode {
    var eventCode: String
    
    init(eventCode: String) {
        self.eventCode = eventCode
    }
}
