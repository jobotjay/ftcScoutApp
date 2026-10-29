//
//  MatchDetailView.swift
//  ftcScoutApp
//
//  Created by Jonas Jay on 9/28/26.
//

import SwiftUI

struct DecodeMatchDetailView: View {
    let match: DecodeMatchScores?
    let eventCode: String
    let season: Int
    @State var matchNumber: Int = 1
    @State var matchResults: MatchResults?
    @State var errorMessage: String = ""
    
    var body: some View {
        ScrollView {
            VStack {
                if match != nil {
                    let teams = match!.alliances
                    let matchNumber = (match?.matchLevel == "QUALIFICATION" ? match!.matchNumber : match!.matchSeries)
                    
                    ForEach(Array(teams.enumerated()), id: \.element) { index, team in
                        
                        Grid {
                            Text("\(team.alliance)")
                                .bold()
                                .font(.title)
                                .bold()
                            //Text("\(matchResults?.matches)")
                            //Text(errorMessage)
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
                                Text("\(team.autoClassifiedArtifacts)")
                            }
                            GridRow {
                                Text("Overflow Artifacts:")
                                Text("\(team.autoOverflowArtifacts)")
                            }
                            GridRow {
                                Text("Classifier State:")
                                HStack {
                                    ForEach(team.autoClassifierState, id: \.self) { ball in
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
                                Text("\(team.robot1Auto)")
                            }
                            GridRow {
                                Text("Robot 2 Auto:")
                                Text("\(team.robot2Auto)")
                            }
                            GridRow {
                                Text("Leave Points:")
                                Text("\(team.autoLeavePoints)")
                            }
                            GridRow {
                                Text("Artifact Points:")
                                Text("\(team.autoArtifactPoints)")
                            }
                            GridRow {
                                Text("Pattern Points:")
                                Text("\(team.autoPatternPoints)")
                            }
                            GridRow {
                                Text("Total Auto Points:")
                                Text("\(team.autoPoints)")
                            }
                            .bold()
                            Text("Teleop")
                                .bold()
                                .font(.title2)
                            GridRow {
                                Text("Classified Artifacts:")
                                Text("\(team.teleopClassifiedArtifacts)")
                            }
                            GridRow {
                                Text("Overflow Artifacts:")
                                Text("\(team.teleopOverflowArtifacts)")
                            }
                            GridRow {
                                Text("Depot Artifacts:")
                                Text("\(team.teleopDepotArtifacts)")
                            }
                            GridRow {
                                Text("Classifier State:")
                                HStack {
                                    ForEach(team.teleopClassifierState, id: \.self) { ball in
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
                                Text("\(team.robot1Teleop)")
                            }
                            GridRow {
                                Text("Robot 2 Park:")
                                Text("\(team.robot2Teleop)")
                            }
                            GridRow {
                                Text("Artifact Points:")
                                Text("\(team.teleopArtifactPoints)")
                            }
                            GridRow {
                                Text("Depot Points:")
                                Text("\(team.teleopDepotPoints)")
                            }
                            GridRow {
                                Text("Pattern Points:")
                                Text("\(team.teleopPatternPoints)")
                            }
                            GridRow {
                                Text("Base Points:")
                                Text("\(team.teleopBasePoints)")
                            }
                            GridRow {
                                Text("Total Teleop Points:")
                                Text("\(team.teleopPoints)")
                            }
                            .bold()
                            .padding(.bottom)
                            GridRow {
                                Text("Movement RP:")
                                Text("\(team.movementRP)")
                            }
                            GridRow {
                                Text("Goal RP:")
                                Text("\(team.goalRP)")
                            }
                            GridRow {
                                Text("Pattern RP:")
                                Text("\(team.patternRP)")
                            }
                            GridRow {
                                Text("Foul Points Committed:")
                                Text("\(team.foulPointsCommitted)")
                            }
                            GridRow {
                                Text("Major Fouls Committed:")
                                Text("\(team.majorFouls)")
                            }
                            GridRow {
                                Text("Minor Fouls Committed:")
                                Text("\(team.minorFouls)")
                            }
                            GridRow {
                                Text("Pre-Foul Total:")
                                Text("\(team.preFoulTotal)")
                            }
                            GridRow {
                                Text("Total Points:")
                                Text("\(team.totalPoints)")
                            }
                            .bold()
                            .font(.title3)
                        }
                        .padding()
                    }
                    .task {
                        do {
                            
                            matchResults = try await NetworkManager.shared.fetchRankings(urlString: "https://ftc-api.firstinspires.org/v2.0/\(season)/matches/\(eventCode)?tournamentLevel=\(match?.matchLevel == "QUALIFICATION" ? "qual" : "playoff")", outputType: MatchResults.self)
                        } catch {
                            errorMessage = error.localizedDescription
                        }
                    }
                }
                
                
            }
        }
    }
}



#Preview {
    @Previewable @State var testMatch: DecodeScoreDetails?
    DecodeMatchDetailView(match: testMatch?.matchScores[0], eventCode: "USNCCOQ", season: 2025)
        .task{
            do {
                testMatch = try await NetworkManager.shared.fetchRankings(urlString: "https://ftc-api.firstinspires.org/v2.0/2025/scores/USNCCOQ/qual?teamNumber=6837", outputType: DecodeScoreDetails.self)
            } catch {
                
            }
        }
}
