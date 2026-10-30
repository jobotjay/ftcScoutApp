//
//  Alliances.swift
//  ftcScoutApp
//
//  Created by Jonas Jay on 9/28/26.
//

import Foundation
import SwiftUI

struct DecodeAlliance: Codable, Hashable {
    let autoClassifiedArtifacts: Int
    let autoOverflowArtifacts: Int
    let autoClassifierState: [String]
    let robot1Auto: Bool
    let robot2Auto: Bool
    let autoLeavePoints: Int
    let autoArtifactPoints: Int
    let autoPatternPoints: Int
    let teleopClassifiedArtifacts: Int
    let teleopOverflowArtifacts: Int
    let teleopDepotArtifacts: Int
    let teleopClassifierState: [String]
    let robot1Teleop: String
    let robot2Teleop: String
    let teleopArtifactPoints: Int
    let teleopDepotPoints: Int
    let teleopPatternPoints: Int
    let teleopBasePoints: Int
    let autoPoints: Int
    let teleopPoints: Int
    let foulPointsCommitted: Int
    let preFoulTotal: Int
    let movementRP: Bool
    let goalRP: Bool
    let patternRP: Bool
    let totalPoints: Int
    let majorFouls: Int
    let minorFouls: Int
    let alliance: String
    let team: Int
    
    @ViewBuilder
    var detailView: some View {
        Grid {
            Text("Auto")
                .bold()
                .font(.title2)
            
            GridRow {
                Text("Classified Artifacts:")
                Text("\(autoClassifiedArtifacts)")
            }
            GridRow {
                Text("Overflow Artifacts:")
                Text("\(autoOverflowArtifacts)")
            }
            GridRow {
                Text("Classifier State:")
                HStack {
                    ForEach(autoClassifierState, id: \.self) { ball in
                        var color: Color {
                            if ball == "PURPLE" {
                                return .purple
                            } else if ball == "GREEN" {
                                return .green
                            } else {
                                return .black
                            }
                        }
                        ZStack {
                            Circle()
                                .frame(width: 17.5)
                                .foregroundStyle(.white)
                            Circle()
                                .frame(width: 15)
                                .foregroundStyle(color)
                        }
                        
                    }
                }
                
            }
            GridRow {
                Text("Robot 1 Auto:")
                Text("\(robot1Auto)")
            }
            GridRow {
                Text("Robot 2 Auto:")
                Text("\(robot2Auto)")
            }
            GridRow {
                Text("Leave Points:")
                Text("\(autoLeavePoints)")
            }
            GridRow {
                Text("Artifact Points:")
                Text("\(autoArtifactPoints)")
            }
            GridRow {
                Text("Pattern Points:")
                Text("\(autoPatternPoints)")
            }
            GridRow {
                Text("Total Auto Points:")
                Text("\(autoPoints)")
            }
            .bold()
            Text("Teleop")
                .bold()
                .font(.title2)
            GridRow {
                Text("Classified Artifacts:")
                Text("\(teleopClassifiedArtifacts)")
            }
            GridRow {
                Text("Overflow Artifacts:")
                Text("\(teleopOverflowArtifacts)")
            }
            GridRow {
                Text("Depot Artifacts:")
                Text("\(teleopDepotArtifacts)")
            }
            GridRow {
                Text("Classifier State:")
                HStack {
                    ForEach(teleopClassifierState, id: \.self) { ball in
                        var color: Color {
                            if ball == "PURPLE" {
                                return .purple
                            } else if ball == "GREEN" {
                                return .green
                            } else {
                                return .black
                            }
                        }
                        ZStack {
                            Circle()
                                .frame(width: 17.5)
                                .foregroundStyle(.white)
                            Circle()
                                .frame(width: 15)
                                .foregroundStyle(color)
                        }
                        
                    }
                }
            }
            GridRow {
                Text("Robot 1 Park:")
                Text("\(robot1Teleop)")
            }
            GridRow {
                Text("Robot 2 Park:")
                Text("\(robot2Teleop)")
            }
            GridRow {
                Text("Artifact Points:")
                Text("\(teleopArtifactPoints)")
            }
            GridRow {
                Text("Depot Points:")
                Text("\(teleopDepotPoints)")
            }
            GridRow {
                Text("Pattern Points:")
                Text("\(teleopPatternPoints)")
            }
            GridRow {
                Text("Base Points:")
                Text("\(teleopBasePoints)")
            }
            GridRow {
                Text("Total Teleop Points:")
                Text("\(teleopPoints)")
            }
            .bold()
            .padding(.bottom)
            GridRow {
                Text("Movement RP:")
                Text("\(movementRP)")
            }
            GridRow {
                Text("Goal RP:")
                Text("\(goalRP)")
            }
            GridRow {
                Text("Pattern RP:")
                Text("\(patternRP)")
            }
            GridRow {
                Text("Foul Points Committed:")
                Text("\(foulPointsCommitted)")
            }
            GridRow {
                Text("Major Fouls Committed:")
                Text("\(majorFouls)")
            }
            GridRow {
                Text("Minor Fouls Committed:")
                Text("\(minorFouls)")
            }
            GridRow {
                Text("Pre-Foul Total:")
                Text("\(preFoulTotal)")
            }
            GridRow {
                Text("Total Points:")
                Text("\(totalPoints)")
            }
            .bold()
            .font(.title3)
            .padding(.bottom)
        }
    }
}
