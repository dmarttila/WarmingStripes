//
//  AboutView.swift
//  
//
//  Created by Doug Marttila on 10/27/21.
//

import SwiftUI

struct AboutAppQA {
    // swiftlint:disable line_length
    let qas = [
        QuestionAnswer(
            question: "What does the app do?",
            answer: "Shows the rise in global temperatures over the last 172 years. Each bar represents a year. Each bar's color is calculated by comparing that year's global average temperature to the 1961-1990 reference period."
        ),

        QuestionAnswer(
            question: "Who came up with the idea?",
            answer:
            """
            [Ed Hawkins](http://www.met.reading.ac.uk/~ed/home/index.php). The orignal website is [here](https://showyourstripes.info/l/globe). You can support Ed Hawkins's environmental work [here](https://showyourstripes.info/support).
            """
        ),
        QuestionAnswer(
            question: "Does this app add any features?",
            answer: "It supports the Fahrenheit temperature scale and if you tap the charts, a rollover is displayed showing the year and anomaly value."
        ),
        QuestionAnswer(
            question: "Where is the data from?",
            answer:
            """
            HadCRUT.5 data were obtained from [the Met Office Hadley Centre observations datasets]( http://www.metoffice.gov.uk/hadobs/hadcrut5) on August 14, 2022 and are © British Crown Copyright, Met Office 2022, provided under an [Open Government License](http://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/).
            """
        ),
        QuestionAnswer(
            question: "Is there a support page?",
            answer: "[Yes](https://www.forestandthetrees.com/climate-warming-stripes/)."
        ),
        QuestionAnswer(
            question: "Do you have other apps?",
            answer: "[Yes](https://apps.apple.com/tt/developer/douglas-marttila/id1596329457)."
        )
    ]
}

struct AboutView: View, AppBundleInfo {
    let qas = AboutAppQA().qas
    var license: LocalizedStringKey {
        """
        \(appName) is licensed under a [Creative Commons Attribution 4.0 International License](https://creativecommons.org/licenses/by/4.0/). 
        Original licensor: [Ed Hawkins, University of Reading](http://www.met.reading.ac.uk/~ed/home/index.php).
        
        This app was built by [Doug Marttila](https://www.forestandthetrees.com/).
        """
    }

    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    ForEach(qas) {
                        QuestionAnswerView(questionAnswer: $0)
                    }
                    Text(license)
                        .modifier(AnswerStyle())
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
// swiftlint:enable line_length
