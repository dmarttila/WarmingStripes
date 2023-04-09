//
//  AboutView.swift
//  
//
//  Created by Doug Marttila on 10/27/21.
//

import SwiftUI
struct AboutAppQA {
    let qas = [
        QuestionAnswer(
            question: "What does the app do?",
            answer: "Shows how global temperatures have risen over the last 70 years."
        ),

        QuestionAnswer(
            question: "Who came up with the idea?",
            answer: "[Ed Hawkins](http://www.met.reading.ac.uk/~ed/home/index.php). Please [chcek out his website](https://showyourstripes.info/l/globe). It has a lot more data than this app."
        ),
        QuestionAnswer(
            question: "So you just stole his idea?",
            answer: """
Pretty much. I wanted to learn [the new charting framework for iOS](https://developer.apple.com/documentation/charts).
Plus the app's free, I gave credit, and [all the code is open source](https://github.com/dmarttila/WarmingStripes).
But, yes, Ed Hawkins deserves all the credit. You can support his environemntal work [here](https://showyourstripes.info/support).
"""
        ),
        QuestionAnswer(
            question: "Where is the data from?",
            answer: """
HadCRUT.5 data were obtained from [the Met Office Hadley Centre observations datasets]( http://www.metoffice.gov.uk/hadobs/hadcrut5) on August 14, 2022 and are © British Crown Copyright,
Met Office 2022, provided under an [Open Government License](http://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/).
"""
        ),
        QuestionAnswer(
            question: "Do you have other apps?",
            answer: "[Yes](https://apps.apple.com/tt/developer/douglas-marttila/id1596329457)"
            ),
        QuestionAnswer(
            question: "Do you have a website?",
            answer: "[Yes]( https://www.forestandthetrees.com/)"
            )
    ]
}

struct AboutView: View {
    let qas = AboutAppQA().qas
    let copyright = Preferences.appTitle + " " + Preferences.version + "\nDoug Marttila " + Date().getCopyright(startYear: 2023)

    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text(copyright)
                        .font(.headline)
                    ForEach(qas) {
                        QuestionAnswerView(questionAnswer: $0)
                    }
                }
                .padding()
                .navigationTitle("About")
            }
        }
    }
}

struct AboutView_Previews: PreviewProvider {
    static var previews: some View {
        AboutView()
    }
}
