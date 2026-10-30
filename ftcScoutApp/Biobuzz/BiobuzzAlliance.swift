//
//  BiobuzzAlliance.swift
//  ftcScoutApp
//
//  Created by Jonas Jay on 10/14/26.
//

import Foundation
import SwiftUI

struct BiobuzzAlliance: Codable, Hashable {
    let autoHiveTips: Int
    let autoRobot1Leave: Bool
    let autoRobot2Leave: Bool
    let autoRobot1Park: Bool
    let autoRobot2Park: Bool
    let autoLeavePoints: Int
    let autoParkPoints: Int
    let autoHivePoints: Int
    let teleopHiveTips: Int
    let teleopHivePollenNectar: Int
    let redAllianceFlower: [String]
    let scoringFlower: [String]
    let blueAllianceFlower: [String]
    let audienceFlower: [String]
    let teleopGardenPollenNectar: Int
    let teleopRobot1Park: Bool
    let teleopRobot2Park: Bool
    let teleopHivePoints: Int
    let teleopFlowerPoints: Int
    let teleopGardenPoints: Int
    let teleopParkPoints: Int
    let autoPoints: Int
    let teleopPoints: Int
    let foulPointsCommitted: Int
    let preFoulTotal: Int
    let swarmRP: Bool
    let pollinator1RP: Bool
    let pollinator2RP: Bool
    let totalPoints: Int
    let majorFouls: Int
    let minorFouls: Int
    let alliance: String
    let team: Int
    
    @ViewBuilder
    var detailView: some View {
        
    }
}
