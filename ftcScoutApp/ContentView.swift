//
//  ContentView.swift
//  ftcScoutApp
//
//  Created by Jonas Jay on 9/22/26.
//

import SwiftUI
import SwiftData
import CodeScanner
import AVFoundation

struct ContentView: View {
    @State private var rankings: Rankings?
    @State private var errorMessage: String?
    @State private var eventCode = "USNCCOQ"
    @State private var answer: Answer?
    @State private var answerIndex: Int = 0
    @State private var season: Int = 2025
    @State private var importedList: [ChunkContainer] = []
    @State private var importedData: Data = Data()
    @State private var totalChunks: Int?
    @State private var numChunks: Int?

    @Environment(\.modelContext) private var modelContext
    @Query(sort: \TeamNotes.team) private var teamNotes: [TeamNotes]
    @Query(sort: \Question.index) private var questions: [Question]
    @Query(sort: \Answer.teamNumber) private var answers: [Answer]
    @Query private var eventCodeModel: [EventCode]

    var body: some View {
        VStack {
            
            //Text("\(answers.map(\.answers))")
            //Main Body
            
            NavigationStack {
//                ScrollView {
//                    //Text(String(data: importedData?.chunk ?? Data(), encoding: .utf8) ?? "")
//                    Text("\(String(data: importedData, encoding: .utf8) ?? "")")
//                }
                // Event code text field
                HStack {
                    
                    Menu("\(season.formatted(.number.grouping(.never)))") {
                        Button("2025") {
                            season = 2025
                        }
                        Button("2026") {
                            season = 2026
                        }
                    }
                    
                    TextField("Event Code", text: $eventCode)
                        .onSubmit {
                            eventCodeModel[0].eventCode = eventCode
                            rankings = nil
                            Task {
                                self.errorMessage = nil
                                do {
                                    self.rankings = try await NetworkManager.shared.fetchRankings(urlString: "https://ftc-api.firstinspires.org/v2.0/\(season)/rankings/\(eventCode)", outputType: Rankings.self)
                                } catch {
                                    self.errorMessage = error.localizedDescription
                                }
                            }
                        }
                        .onAppear {
                            if eventCodeModel.isEmpty {
                                modelContext.insert(EventCode(eventCode: "USNCCOQ"))
                            }
                            try! modelContext.save()
                            eventCode = eventCodeModel[0].eventCode
                        }
                    NavigationLink {
                        VStack {
                            if numChunks != nil {
                                Text("\(numChunks!) out of \(totalChunks!) scanned")
                            }
                            CodeScannerView(codeTypes: [.qr], scanMode: .oncePerCode, scanInterval: 0.1, showViewfinder: true, shouldVibrateOnSuccess: false) { response in
                                switch response {
                                case .success(let result):
                                    let qrResponse = result.string
                                    //print(qrResponse)
                                    
                                    let decodedResponse = try! JSONDecoder().decode(ChunkContainer.self, from: qrResponse.data(using: .utf8)!)
                                    if !importedList.contains(where: {$0.num == decodedResponse.num}) {
                                        importedList.append(decodedResponse)
                                    }
                                    //print(importedList)
                                    numChunks = importedList.count
                                    totalChunks = importedList[0].total
                                    
                                    if importedList.count == importedList[0].total {
                                        //print("Done")
                                        importedList.sort(by: {$0.num < $1.num})
                                        //print(importedList)
                                        importedData = Data()
                                        for chunk in importedList.map(\.chunk) {
                                            importedData += chunk
                                        }
                                        //print(String(data: importedData, encoding: .utf8))
                                        
                                        let importedContainer = try! JSONDecoder().decode(SharingContainer.self, from: importedData)
                                        for answer in importedContainer.answers {
                                            if let index = answers.firstIndex(where: {$0.teamNumber == answer.teamNumber}) {
                                                answers[index].answers = answer.answers
                                            } else {
                                                modelContext.insert(answer)
                                            }
                                        }
                                    }
                                case .failure(let error):
                                    let qrResponse = error.localizedDescription
                                }
                            }
                            .onAppear {
                                importedList = []
                                importedData = Data()
                                numChunks = nil
                                totalChunks = nil
                            }
                        }
                    } label: {
                        Image(systemName: "qrcode.viewfinder")
                    }
                    NavigationLink {
                        SharingView(questions: questions, answers: answers, teamNotes: teamNotes)
                    } label: {
                        Image(systemName: "qrcode")
                    }
                    NavigationLink {
                        QuestionAdderView(questions: questions) { index, content, order in
                            let maxIndex = (questions.map(\.index)).max()
                            if index > maxIndex ?? -1 {
                                modelContext.insert(Question(index: index, question: content, order: order))
                            } else {
                                let questionIndex = questions.firstIndex(where: {$0.index == index})
                                questions[questionIndex!].question = content
                                questions[questionIndex!].order = order
                            }
                            try! modelContext.save()
                        } onDelete: { index in
                            let questionToDelete = questions[index]
                            modelContext.delete(questionToDelete)
                        } onMove: { sources, destinations in
                            for (index,order) in zip(sources,destinations) {
                                let questionIndex = questions.firstIndex(where: {$0.index == index})
                                questions[questionIndex!].order = order
                            }
                            
                            try! modelContext.save()
                        }
                    } label: {
                        Image(systemName: "gear")
                    }
                }
                
                if errorMessage != nil {
                    Text(errorMessage!)
                }
                
                // Labels
                HStack{
                    Text("Rank")
                        .padding(.leading, 10)
                    Spacer()
                    Text("Team Name")
                    Spacer()
                    Text("Team Number")
                        .padding(.trailing, 10)
                }
                .bold()
                
                Divider()
                //Team area
                ScrollView {
                    
                    if rankings != nil {
                        ForEach(rankings!.rankings) { team in
                            NavigationLink {
                                if let index = teamNotes.firstIndex(where: {$0.team == team.teamNumber}) {
                                    
                                    
                                    if !(answer == nil) {
                                        
                                        TeamDetailView(team: team, teamNote: teamNotes[index].notes, eventCode: eventCode, season: season, questions: questions, answers: answers.first(where: {$0.teamNumber == team.teamNumber})!.answers) { updatedNotes in
                                            teamNotes[index].notes = updatedNotes
                                            try! modelContext.save()
                                        } editQuestion: { i, newAnswers in
                                            answerIndex = answers.firstIndex(where: {$0.teamNumber == team.teamNumber})!
                                            answers[answerIndex].answers = newAnswers
                                            try! modelContext.save()
                                        }
                                        
                                    }
                                    
                                    
                                } else {

                                    if !(answer == nil) {
                                        TeamDetailView(team: team, teamNote: "", eventCode: eventCode, season: season, questions: questions, answers: answers.first(where: {$0.teamNumber == team.teamNumber})!.answers) { updatedNotes in
                                            let newNote = TeamNotes(team: team.teamNumber, notes: updatedNotes)
                                            modelContext.insert(newNote)
                                            try! modelContext.save()
                                        } editQuestion: { i, newAnswers in
                                            answerIndex = answers.firstIndex(where: {$0.teamNumber == team.teamNumber})!
                                            answers[answerIndex].answers = newAnswers
                                            try! modelContext.save()
                                        }
                                        .onAppear {
                                            modelContext.insert(TeamNotes(team: team.teamNumber, notes: ""))
                                        }
                                    }
            
                                    
                                }
                                    
                            } label: {
                                HStack {
                                    Text(String(team.rank))
                                        .padding(.leading, 10)
                                    Spacer()
                                    Text(team.teamName)
                                    Spacer()
                                    Text(String(team.teamNumber))
                                        .padding(.trailing, 10)
                                }
                                
                            }
                            .onAppear {
                                if !answers.contains(where: {$0.teamNumber == team.teamNumber}) {
                                    
                                    modelContext.insert(Answer(teamNumber: team.teamNumber, answers: []))
                                    try! modelContext.save()
                                    
                                }
                                answer = answers.first(where: {$0.teamNumber == team.teamNumber})!
                            }
                            
                            
                            Divider()
                            
                        }
                    } else {
                        Text("Loading...")
                    }
                    
                    Group {
                        Text("Made by team 6837 C.R.A.S.H")
                        Text("Made using the [FTC Events API](https://ftc-events.firstinspires.org/services/API)")
                    }
                    .font(.footnote)
                    
            }
            .task {
                
                do {
                    self.rankings = try await NetworkManager.shared.fetchRankings(urlString: "https://ftc-api.firstinspires.org/v2.0/\(season)/rankings/\(eventCode)", outputType: Rankings.self)
                } catch {
                    self.errorMessage = error.localizedDescription
                }
            }
                
                
            }
        }
        .padding()
        
    }
}


#Preview {
    
    ContentView()
        .modelContainer(for: [TeamNotes.self, Question.self, Answer.self, EventCode.self], inMemory: true)
}
