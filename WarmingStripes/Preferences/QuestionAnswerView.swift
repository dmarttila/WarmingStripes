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
                .textStyle(QuestionStyle())
            Text(qa.answer)
                .textStyle(AnswerStyle())
        }
    }
}


struct QuestionAnswer: Identifiable {
    let question: String
    let answer: String
    let id: UUID
    init (id: UUID = UUID(), question: String, answer: String) {
        self.id = id
        self.question = question
        self.answer = answer
    }
}

struct QuestionAnswerView_Previews: PreviewProvider {
    static let q = "Is weekly fasting healthy?"
    static let a = "You got me. I'm not a nutritionist. Searching online, it seems like it is. All I know is, since I started: I've lost a ton of weight; I eat less; I have fewer aches and pains; and I have more energy. But maybe I'll drop dead tomorrow. Also, probably not great for kids."
    static let qa = QuestionAnswer(question: q, answer: a)
    static var previews: some View {
        QuestionAnswerView(qa: qa)
    }
}
