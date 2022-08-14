//
//  QuestionAnswerView.swift
//  IntermittentFasting
//
//  Created by Doug Marttila on 10/28/21.
//

import SwiftUI

struct QuestionAnswerView: View {
    let qa: QuestionAnswer
    var body: some View {
        VStack (alignment: .leading, spacing: 6) {
            Text(qa.question)
                .modifier(QuestionStyle())
            Text(qa.answer)
                .modifier(AnswerStyle())
        }
    }
}


struct QuestionAnswer: Identifiable {
    let question: LocalizedStringKey
    let answer: LocalizedStringKey
    let id: UUID
    init (id: UUID = UUID(), question: LocalizedStringKey, answer: LocalizedStringKey) {
        self.id = id
        self.question = question
        self.answer = answer
    }
}

struct QuestionAnswerView_Previews: PreviewProvider {
    static let q: LocalizedStringKey = "Is weekly fasting healthy?"
    static let a: LocalizedStringKey = "[Ed Hawkins](http://www.met.reading.ac.uk/~ed/home/index.php)"
    static let qa = QuestionAnswer(question: q, answer: a)
    static var previews: some View {
        QuestionAnswerView(qa: qa)
    }
}
