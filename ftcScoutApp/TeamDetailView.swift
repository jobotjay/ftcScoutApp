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
    let season: Int
    let questions: [Question]
    let answers: [String]
    @State var autoPoints = 0
    @State var newNotes: String = ""
    @State var scoreDetailsQuals: Any?
    @State var scoreDetailsPlayoffs: Any?
    @State var errorMessage = ""
    @State var newAnswers: [String] = []
    @State var maxIndex: Int = 0
    @State var seasonType: ScoreDetails.Type = BiobuzzScoreDetails.self
    var onSave: (String) -> Void = { _ in }
    var editQuestion: (Int, [String]) -> Void = { _,_ in }

    var body: some View {
        NavigationStack {
            ScrollView {
                
                //Text(errorMessage)
                
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
                        
                        if let qualsConverted = scoreDetailsQuals! as? DecodeScoreDetails {
                            ForEach(0..<qualsConverted.matchScores.count) { index in
                                NavigationLink {
                                    DecodeMatchDetailView(match: qualsConverted.matchScores[index], eventCode: eventCode, season: season)
                                } label: {
                                    Text("\(qualsConverted.matchScores[index].matchLevel) \(qualsConverted.matchScores[index].matchNumber)")
                                }
                            }
                        } else if let qualsConverted = scoreDetailsQuals! as? BiobuzzScoreDetails {
                            ForEach(0..<qualsConverted.matchScores.count) { index in
                                NavigationLink {
                                    BiobuzzMatchDetailView(match: qualsConverted.matchScores[index], eventCode: eventCode, season: season)
                                } label: {
                                    Text("\(qualsConverted.matchScores[index].matchLevel) \(qualsConverted.matchScores[index].matchNumber)")
                                }
                            }
                        }
                    }
                    if scoreDetailsPlayoffs != nil {
                        if let playoffsConverted = scoreDetailsPlayoffs as? DecodeScoreDetails {
                            ForEach(0..<playoffsConverted.matchScores.count) { index in
                                NavigationLink {
                                    DecodeMatchDetailView(match: playoffsConverted.matchScores[index], eventCode: eventCode, season: season)
                                } label: {
                                    Text("\(playoffsConverted.matchScores[index].matchLevel) \(playoffsConverted.matchScores[index].matchSeries)")
                                }
                            }
                        } else if let playoffsConverted = scoreDetailsPlayoffs as? BiobuzzScoreDetails {
                            ForEach(0..<playoffsConverted.matchScores.count) { index in
                                NavigationLink {
                                    BiobuzzMatchDetailView(match: playoffsConverted.matchScores[index], eventCode: eventCode, season: season)
                                } label: {
                                    Text("\(playoffsConverted.matchScores[index].matchLevel) \(playoffsConverted.matchScores[index].matchSeries)")
                                }
                            }
                        }
                    }
                    
                    Rectangle()
                        .fill(Color.gray)
                        .frame(height: 1)
                    
                    let sortedQuestions = questions.sorted {$0.order < $1.order}
                    
//                    Text("\(newAnswers)")
//                    Text("\(maxIndex)")
                    ForEach(Array(sortedQuestions.enumerated()), id: \.element.id) { index, question in
                        HStack {
                            Text(question.question)
                            

                            if newAnswers.count - 1 >= maxIndex {
                                TextField("Answer", text: $newAnswers[question.index])
                                    .onSubmit {
                                        editQuestion(index, newAnswers)
                                    }
                                //Text("\(question.index)")
                            }
                        }
                    }
                    .padding()
                    .onAppear {
                        //print(answers)
                        newAnswers = answers
                        maxIndex = (questions.map(\.index)).max() ?? -1
                        while (newAnswers.count - 1 < maxIndex) {
                            newAnswers.append("")
                        }
                    }
                    
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
                        if season == 2025 {
                            seasonType = DecodeScoreDetails.self
                        } else if season == 2026 {
                            seasonType = BiobuzzScoreDetails.self
                        }
                        self.scoreDetailsQuals = try await NetworkManager.shared.fetchRankings(urlString: "https://ftc-api.firstinspires.org/v2.0/\(season)/scores/\(eventCode)/qual?teamNumber=\(team.teamNumber)", outputType: seasonType)
                        self.scoreDetailsPlayoffs = try await NetworkManager.shared.fetchRankings(urlString: "https://ftc-api.firstinspires.org/v2.0/\(season)/scores/\(eventCode)/playoff?teamNumber=\(team.teamNumber)", outputType: seasonType)
                    } catch {
                        self.errorMessage = error.localizedDescription
                    }
                }
            }
        }
        .onAppear {
            if season == 2025 {
                seasonType = DecodeScoreDetails.self
            } else if season == 2026 {
                seasonType = BiobuzzScoreDetails.self
            }
        }
    }
}

#Preview {
    TeamDetailView(team: Team(teamNumber: 19792), teamNote: "", eventCode: "USNVLVS", season: 2026, questions: [Question(index: 0, question: "What is your favorite color?", order: 0), Question(index: 1, question: "What is your favorite food?", order: 1)], answers: [])
        
}
