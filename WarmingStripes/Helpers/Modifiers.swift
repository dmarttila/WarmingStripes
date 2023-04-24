//
//  Modifiers.swift
//  WarmingStripes
//
//  Created by Doug Marttila on 8/13/22.
//

import SwiftUI

struct AnswerStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.body)
            .multilineTextAlignment(.leading)
            .lineLimit(nil)
            .fixedSize(horizontal: false, vertical: true)
    }
}

struct QuestionStyle: ViewModifier {
    let font = Font.body.italic()
    func body(content: Content) -> some View {
        content
            .multilineTextAlignment(.leading)
            .lineLimit(nil)
            .fixedSize(horizontal: false, vertical: true)
            .font(font)
    }
}
