//
//  QuestionAdderView.swift
//  ftcScoutApp
//
//  Created by Jonas Jay on 10/4/26.
//

import SwiftUI

struct QuestionAdderView: View {
    let questions: [Question]
    @State private var newQuestion: [Question] = []
    var onSave: (Int, String, Int) -> Void
    var onDelete: (Int) -> Void
    var onMove: ([Int], [Int]) -> Void
    
    var body: some View {
//        Text("\(newQuestion.map(\.index))")
//        Text("\(questions.map(\.index))")
//        Text("\(questions.map(\.question))")
        List {
            ForEach($newQuestion) { $question in
                HStack {
                    TextField("Text", text: $question.question)
                        .onSubmit {
                            onSave(question.index, question.question, question.order)
                        }
//                    Text("\(question.order)")
//                    Text("\(question.index)")
                }
            }
            .onDelete(perform: deleteItems)
            .onMove(perform: moveItems)
        }
        .onAppear {
            newQuestion = questions.sorted {$0.order < $1.order}
        }
        Button("Add", systemImage: "plus.circle") {
            let newIndex = (questions.last?.index).map {$0 + 1}
            let maxOrder = (questions.map(\.order)).max()
            let newOrder = (maxOrder).map {$0 + 1}
            if !(newOrder == nil) {
                let addedQuestion = Question(index: newIndex!, question: "New question", order: newOrder!)
                newQuestion.append(addedQuestion)
                onSave(addedQuestion.index, addedQuestion.question, addedQuestion.order)
            } else {
                let addedQuestion = Question(index: 0, question: "New question", order: 0)
                newQuestion.append(addedQuestion)
                onSave(addedQuestion.index, addedQuestion.question, addedQuestion.order)
            }
            
        }
    }
    
    func deleteItems(at offsets: IndexSet) {
        newQuestion.remove(atOffsets: offsets)
        onDelete(offsets.first!)
    }
    
    func moveItems(from source: IndexSet, to destination: Int) {
        newQuestion.move(fromOffsets: source, toOffset: destination)
        print(newQuestion.map(\.index))
        onMove(newQuestion.map(\.index), Array(0..<newQuestion.count))
    }
}

#Preview {
    QuestionAdderView(questions: [Question(index: 0, question: "What is your favorite color?", order: 0), Question(index: 1, question: "What is your favorite food?", order: 1)]) { _,_,_ in
        
    } onDelete: { _ in
        
    } onMove: { _, _ in
        
    }
}
