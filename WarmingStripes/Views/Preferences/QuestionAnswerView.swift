//
//  QuestionAnswerView.swift
//
//  Created by Doug Marttila on 10/28/21.
//

import SwiftUI

struct QuestionAnswerView: View {
    let questionAnswer: QuestionAnswer
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(questionAnswer.question)
                .modifier(QuestionStyle())
            Text(questionAnswer.answer)
                .modifier(AnswerStyle())
        }
    }
}

struct QuestionAnswer: Identifiable {
    let question: LocalizedStringKey
    let answer: LocalizedStringKey
    let id: UUID
    init(id: UUID = UUID(), question: LocalizedStringKey, answer: LocalizedStringKey) {
        self.id = id
        self.question = question
        self.answer = answer
    }
}

struct QuestionAnswerView_Previews: PreviewProvider {
    static let question: LocalizedStringKey = "Whose idea was this?"
    static let answer: LocalizedStringKey = "[Ed Hawkins](http://www.met.reading.ac.uk/~ed/home/index.php)"
    static let questionAnswer = QuestionAnswer(question: question, answer: answer)
    static var previews: some View {
        QuestionAnswerView(questionAnswer: questionAnswer)
    }
}
