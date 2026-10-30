//
//  BiobuzzMatchDetailView.swift
//  ftcScoutApp
//
//  Created by Jonas Jay on 10/15/26.
//

import SwiftUI

struct BiobuzzMatchDetailView: View {
    let match: BiobuzzMatchScores?
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
                    
                
                    Text("Flowers:")
                        .bold()
                        .font(.title2)
                    
                    HStack {
                        
                        let flowers = [teams[0].redAllianceFlower, teams[0].scoringFlower, teams[0].blueAllianceFlower, teams[0].audienceFlower]
                        ForEach(0..<4) { index in
                            VStack {
                                VStack {
                                    Spacer()
                                    ForEach(flowers[index], id: \.self) { ball in
                                        var color: Color {
                                            if ball == "RED_NECTAR" {
                                                return .red
                                            } else if ball == "BLUE_NECTAR" {
                                                return .blue
                                            } else if ball == "POLLEN" {
                                                return .yellow
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
                                .frame(width: 15,height: 200)
                                .padding(10)
                                .background(Color(uiColor: .secondarySystemBackground))
                                .cornerRadius(10)
                                
                                Text(["Red Alliance","Scoring","Blue Alliance","Audiance"][index])
                            }
                            
                        }
                    }
                    .padding(.vertical)
                    
                    ForEach(Array(teams.enumerated()), id: \.element) { index, team in
                        Grid {
                            Text("\(team.alliance)")
                                .bold()
                                .font(.title)
                                .bold()
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
                                Text("Hive Tips:")
                                Text("\(team.autoHiveTips)")
                            }
                            GridRow {
                                Text("Robot 1 Leave:")
                                Text("\(team.autoRobot1Leave)")
                            }
                            GridRow {
                                Text("Robot 2 Leave:")
                                Text("\(team.autoRobot2Leave)")
                            }
                            GridRow {
                                Text("Robot 1 Park:")
                                Text("\(team.autoRobot1Park)")
                            }
                            GridRow {
                                Text("Robot 2 Park:")
                                Text("\(team.autoRobot2Park)")
                            }
                            GridRow {
                                Text("Leave Points:")
                                Text("\(team.autoLeavePoints)")
                            }
                            GridRow {
                                Text("Park Points:")
                                Text("\(team.autoParkPoints)")
                            }
                            GridRow {
                                Text("Hive Points:")
                                Text("\(team.autoHivePoints)")
                            }
                            GridRow {
                                Text("Total Auto Points:")
                                Text("\(team.autoPoints)")
                            }
                            .bold()
                            .padding(.bottom)
                            
                            Text("Teleop")
                                .bold()
                                .font(.title2)
                            
                            GridRow {
                                Text("Hive Tips:")
                                Text("\(team.teleopHiveTips)")
                            }
                            GridRow {
                                Text("Hive Pollen and Necter:")
                                Text("\(team.teleopHivePollenNectar)")
                            }
                            GridRow {
                                Text("Garden Pollen and Necter:")
                                Text("\(team.teleopGardenPollenNectar)")
                            }
                            GridRow {
                                Text("Robot 1 Park:")
                                Text("\(team.teleopRobot1Park)")
                            }
                            GridRow {
                                Text("Robot 2 Park:")
                                Text("\(team.teleopRobot2Park)")
                            }
                            GridRow {
                                Text("Hive Points:")
                                Text("\(team.teleopHivePoints)")
                            }
                            GridRow {
                                Text("Flower Points:")
                                Text("\(team.teleopFlowerPoints)")
                            }
                            GridRow {
                                Text("Garden Points:")
                                Text("\(team.teleopGardenPoints)")
                            }
                            GridRow {
                                Text("Park Points:")
                                Text("\(team.teleopParkPoints)")
                            }
                            GridRow {
                                Text("Total Teleop Points:")
                                Text("\(team.teleopPoints)")
                            }
                            .bold()
                            .padding(.bottom)
                            
                            GridRow {
                                Text("Swarm RP:")
                                Text("\(team.swarmRP)")
                            }
                            GridRow {
                                Text("Pollinator 1 RP:")
                                Text("\(team.pollinator1RP)")
                            }
                            GridRow {
                                Text("Pollinator 2 RP:")
                                Text("\(team.pollinator2RP)")
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
                                Text("Pre-foul Total:")
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
    @Previewable @State var testMatch: BiobuzzScoreDetails?
    BiobuzzMatchDetailView(match: testMatch?.matchScores[1], eventCode: "KZASN1", season: 2026)
        .task{
            do {
                testMatch = try await NetworkManager.shared.fetchRankings(urlString: "https://ftc-api.firstinspires.org/v2.0/2026/scores/KZASN1/playoff?teamNumber=32717", outputType: BiobuzzScoreDetails.self)
            } catch {
                
            }
        }
}
