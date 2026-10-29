//
//  MatchDetailView.swift
//  ftcScoutApp
//
//  Created by Jonas Jay on 9/28/26.
//

import SwiftUI

struct MatchDetailView: View {
    let match: MatchScores?
    let eventCode: String
    @State var matchNumber: Int = 1
    @State var matchResults: MatchResults?
    @State var errorMessage: String = ""
    
    var body: some View {
        VStack {
            if match != nil {
                let teams = match!.alliances
                let matchNumber = (match?.matchLevel == "QUALIFICATION" ? match!.matchNumber : match!.matchSeries)
                ScrollView {
                    ForEach(Array(teams.enumerated()), id: \.element) {index, score in
                        Grid {
                            Text("\(score.alliance)")
                                .bold()
                                .font(.title)
                            .bold()
                            //Text("\(matchResults?.matches)")
                            Text(errorMessage)
                            HStack {
                                Text(String(matchResults?.matches[matchNumber - 1].teams[(2*index+2) % 4].teamNumber ?? 0))
                                    .padding()
                                Text(String(matchResults?.matches[matchNumber - 1].teams[(2*index+3) % 4].teamNumber ?? 0))
                                    .padding()
                            }
                            .bold()
                            .font(.title3)
                            
                            Text("Auto")
                                .bold()
                                .font(.title2)
                            
                            GridRow {
                                Text("Classified Artifacts:")
                                Text("\(score.autoClassifiedArtifacts)")
                            }
                            GridRow {
                                Text("Overflow Artifacts:")
                                Text("\(score.autoOverflowArtifacts)")
                            }
                            GridRow {
                                Text("Classifier State:")
                                HStack {
                                    ForEach(score.autoClassifierState, id: \.self) { ball in
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
                                Text("\(score.robot1Auto)")
                            }
                            GridRow {
                                Text("Robot 2 Auto:")
                                Text("\(score.robot2Auto)")
                            }
                            GridRow {
                                Text("Leave Points:")
                                Text("\(score.autoLeavePoints)")
                            }
                            GridRow {
                                Text("Artifact Points:")
                                Text("\(score.autoArtifactPoints)")
                            }
                            GridRow {
                                Text("Pattern Points:")
                                Text("\(score.autoPatternPoints)")
                            }
                            GridRow {
                                Text("Total Auto Points:")
                                Text("\(score.autoPoints)")
                            }
                            .bold()
                            Text("Teleop")
                                .bold()
                                .font(.title2)
                            GridRow {
                                Text("Classified Artifacts:")
                                Text("\(score.teleopClassifiedArtifacts)")
                            }
                            GridRow {
                                Text("Overflow Artifacts:")
                                Text("\(score.teleopOverflowArtifacts)")
                            }
                            GridRow {
                                Text("Depot Artifacts:")
                                Text("\(score.teleopDepotArtifacts)")
                            }
                            GridRow {
                                Text("Classifier State:")
                                HStack {
                                    ForEach(score.teleopClassifierState, id: \.self) { ball in
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
                                Text("\(score.robot1Teleop)")
                            }
                            GridRow {
                                Text("Robot 2 Park:")
                                Text("\(score.robot2Teleop)")
                            }
                            GridRow {
                                Text("Artifact Points:")
                                Text("\(score.teleopArtifactPoints)")
                            }
                            GridRow {
                                Text("Depot Points:")
                                Text("\(score.teleopDepotPoints)")
                            }
                            GridRow {
                                Text("Pattern Points:")
                                Text("\(score.teleopPatternPoints)")
                            }
                            GridRow {
                                Text("Base Points:")
                                Text("\(score.teleopBasePoints)")
                            }
                            GridRow {
                                Text("Total Teleop Points:")
                                Text("\(score.teleopPoints)")
                            }
                            .bold()
                            .padding(.bottom)
                            GridRow {
                                Text("Movement RP:")
                                Text("\(score.movementRP)")
                            }
                            GridRow {
                                Text("Goal RP:")
                                Text("\(score.goalRP)")
                            }
                            GridRow {
                                Text("Pattern RP:")
                                Text("\(score.patternRP)")
                            }
                            GridRow {
                                Text("Foul Points Committed:")
                                Text("\(score.foulPointsCommitted)")
                            }
                            GridRow {
                                Text("Major Fouls Committed:")
                                Text("\(score.majorFouls)")
                            }
                            GridRow {
                                Text("Minor Fouls Committed:")
                                Text("\(score.minorFouls)")
                            }
                            GridRow {
                                Text("Pre-Foul Total:")
                                Text("\(score.preFoulTotal)")
                            }
                            GridRow {
                                Text("Total Points:")
                                Text("\(score.totalPoints)")
                            }
                            .bold()
                            .font(.title3)
                            .padding(.bottom)
                        }
                        .padding()
                    }
                }
                .task {
                    do {
                        
                        matchResults = try await NetworkManager.shared.fetchRankings(urlString: "https://ftc-api.firstinspires.org/v2.0/2025/matches/\(eventCode)?tournamentLevel=\(match?.matchLevel == "QUALIFICATION" ? "qual" : "playoff")", outputType: MatchResults.self)
                    } catch {
                        errorMessage = error.localizedDescription
                    }
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var testMatch: ScoreDetails?
    MatchDetailView(match: testMatch?.matchScores[0], eventCode: "USNCCOQ")
        .task{
            do {
                testMatch = try await NetworkManager.shared.fetchRankings(urlString: "https://ftc-api.firstinspires.org/v2.0/2025/scores/USNCCOQ/qual?teamNumber=6837", outputType: ScoreDetails.self)
            } catch {
                
            }
        }
}
