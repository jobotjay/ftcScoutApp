//
//  TeamDetailView.swift
//  ftcScoutApp
//
//  Created by Jonas Jay on 9/23/26.
//

import SwiftUI
import SwiftData

struct TeamDetailView: View {
    let team: Team
    let teamNote: String
    let eventCode: String
    @State var autoPoints = 0
    @State var newNotes: String = ""
    @State var scoreDetailsQuals: ScoreDetails?
    @State var scoreDetailsPlayoffs: ScoreDetails?
    @State var errorMessage = ""
    var onSave: (String) -> Void = { _ in }
    

    var body: some View {
        NavigationStack {
            ScrollView {
                Grid {
                    GridRow {
                        Text("Team Name:")
                        Text(team.teamName)
                    }
                    Divider()
                    GridRow {
                        Text("Team Number:")
                        Text(team.displayTeamNumber)
                    }
                    Divider()
                    GridRow {
                        Text("Rank:")
                        Text(String(team.rank))
                    }
                    Divider()
                    GridRow {
                        Text("Ranking Points:")
                        Text(String(format: "%.2f", team.sortOrder1))
                    }
                    Divider()
                    GridRow {
                        Text("W-L-T:")
                        Text("\(team.wins)-\(team.losses)-\(team.ties)")
                    }
                    Divider()
                    GridRow {
                        Text("Average Qualification Score:")
                        Text(String(format: "%.2f", team.sortOrder2))
                    }
                    
                    
                    
                    Rectangle()
                        .fill(Color.gray)
                        .frame(height: 1)
                    
                    if scoreDetailsQuals != nil {
                        ForEach(0..<scoreDetailsQuals!.matchScores.count) { index in
                            NavigationLink {
                                MatchDetailView(match: scoreDetailsQuals?.matchScores[index], eventCode: eventCode)
                            } label: {
                                Text("\(scoreDetailsQuals?.matchScores[index].matchLevel ?? "") \(scoreDetailsQuals?.matchScores[index].matchNumber ?? 0)")
                            }
                        }
                    }
                    if scoreDetailsPlayoffs != nil {
                        ForEach(0..<scoreDetailsPlayoffs!.matchScores.count) { index in
                            NavigationLink {
                                MatchDetailView(match: scoreDetailsPlayoffs?.matchScores[index], eventCode: eventCode)
                            } label: {
                                Text("\(scoreDetailsPlayoffs?.matchScores[index].matchLevel ?? "") \(scoreDetailsPlayoffs?.matchScores[index].matchSeries ?? 0)")
                            }
                        }
                    }
                    
                    //            GridRow {
                    //                Text("Max Auto Points:")
                    //                TextField("Points", value: $autoPoints, format: .number)
                    //                    .keyboardType(.numberPad)
                    //            }
                    
                    HStack {
                        Text("Notes:")
                            .padding(.leading)
                        Spacer()
                    }
                    ZStack {
                        TextEditor(text: $newNotes)
                            .onChange(of: newNotes) {
                                onSave(newNotes)
                            }
                            .onAppear {
                                newNotes = teamNote
                            }
                            .scrollContentBackground(.hidden)
                            .background(Color(uiColor: .secondarySystemBackground))
                            .cornerRadius(8)
                            .padding(.horizontal)
                            .frame(minHeight: 200)
                        if newNotes == "" {
                            Text("Notes")
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                                .padding(.leading, 21)
                                .padding(.top, 9)
                                .foregroundStyle(Color(uiColor: .placeholderText))
                        }
                    }
                    
                }
                .task {
                    do {
                        self.scoreDetailsQuals = try await NetworkManager.shared.fetchRankings(urlString: "https://ftc-api.firstinspires.org/v2.0/2025/scores/\(eventCode)/qual?teamNumber=\(team.teamNumber)", outputType: ScoreDetails.self)
                        self.scoreDetailsPlayoffs = try await NetworkManager.shared.fetchRankings(urlString: "https://ftc-api.firstinspires.org/v2.0/2025/scores/\(eventCode)/playoff?teamNumber=\(team.teamNumber)", outputType: ScoreDetails.self)
                    } catch {
                        self.errorMessage = error.localizedDescription
                    }
                }
            }
        }
    }
}

#Preview {
    TeamDetailView(team: Team(teamNumber: 6837), teamNote: "", eventCode: "USNCCOQ")
        
}
