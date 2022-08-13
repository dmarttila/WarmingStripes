//
//  AboutView.swift
//  IntermittentFasting
//
//  Created by Doug Marttila on 10/27/21.
//

import SwiftUI
struct AboutAppQA {
    let qas = [
        QuestionAnswer (
            question: "What does the app do?",
            answer: "It tracks your weight, the days you fast, and when you eat on non-fasting days."
        ),
        
        QuestionAnswer (
            question: "How often do you fast?",
            answer: "Once a week."
        ),
        QuestionAnswer (
            question: "Isn't fasting awful?",
            answer: "You get used to it. And I've lost 50lbs."
        ),
        QuestionAnswer (
            question: "Do you eat whatever you want on non-fasting days?",
            answer: "I usually have a small lunch and eat whatever I want for dinner."
        )
    ]
}

struct AboutView: View {
    let qas = AboutAppQA().qas
    let cr = Preferences.appTitle + " " + Preferences.version + "\nDoug Marttila " + Date().getCopyright(startYear: 2021)
    
    var body: some View {
        ZStack {
            Color.lightestClr
                .ignoresSafeArea()
            ScrollView {
                VStack (alignment: .leading, spacing: 20){
                    Text(cr)
                        .font(.headline)
                        .foregroundColor(.secondDarkestClr)
                    ForEach (qas) {
                        QuestionAnswerView(qa: $0)
                    }
                    VStack (alignment: .leading, spacing: 6){
                        Text("Who designed the fasting icons?")
                            .modifier(QuestionStyle())
                        Link("Pelin Kahraman, The Noun Project.", destination: URL(string: "https://thenounproject.com/pelodrome/")!)
                    }
                    VStack (alignment: .leading, spacing: 6){
                        Text("Is there a support page for Fasty?")
                            .modifier(QuestionStyle())
                        Link("Fasty Support", destination: URL(string: "https://www.forestandthetrees.com/fasty-mcfastface/")!)
                    }
                    VStack (alignment: .leading, spacing: 6){
                        Text("What's up with the app name?")
                            .modifier(QuestionStyle())
                        Text("Naming apps is hard.")
                            .modifier(AnswerStyle())
                        Link("And Boaty McBoatface is funny.", destination: URL(string: "https://en.wikipedia.org/wiki/Boaty_McBoatface")!)
                    }
                    
                    //for some unknown reason, on iOS14, when you scroll up the content shows up on top of the title unless there is some extra text. Works fine for iOS15. This text doesn't need to be repeated (it's in privacy) but whatever
                    if #available(iOS 15.0, *) {}
                    else {
                    Spacer()
                        .frame(height:10)
                    Text("No data entered in this application is used for analytics, tracking, or similar activity.")
                        .modifier(AnswerStyle())
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
