//
//  PrivacyView.swift
//  IntermittentFasting
//
//  Created by Doug Marttila on 10/27/21.
//

import SwiftUI

struct PrivacyView: View {
    var body: some View {
        ZStack {
            Color.lightestClr
                .ignoresSafeArea()
            ScrollView {
                VStack (alignment: .leading, spacing: 10){
                    
                    Text("TL;DR: your data is not tracked.")
                        .font(.headline)
                        .foregroundColor(.darkestClr)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Text("All information entered in \(Preferences.appTitle) is only stored on your device. It is not transmitted anywhere. If you backup your device to iCloud, the data will be copied there, but is still only accessible to you.")
                        .textStyle(AnswerStyle())
                    
                    Text("No data entered in this application is used for analytics, tracking, or similar activity.")
                        .textStyle(AnswerStyle())
                    
                    Link("Fasty's privacy policy", destination: URL(string: "https://www.forestandthetrees.com/privacy-policy-for-fasty-mcfastface/")!)
                    Spacer()
                        .frame(height: 10)
                    
                    Text("Data stored in iCloud is governed by:")
                        .textStyle(AnswerStyle())
                    
                    Link("Apple's privacy policy", destination: URL(string: "https://www.apple.com/legal/privacy/en-ww/")!)
                    Spacer()
                }
                .padding(30)
                .navigationTitle("Privacy")
            }
        }
    }
}

struct PrivacyView_Previews: PreviewProvider {
    static var previews: some View {
        PrivacyView()
    }
}
