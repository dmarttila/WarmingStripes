//
//  PrivacyView.swift
//
//  Created by Doug Marttila on 10/27/21.
//

import SwiftUI

struct PrivacyView: View, AppBundleInfo {
    
    var privacyExplanation: String {
    """
    All information entered in \(appName) is only stored on your device.(The only data that is stored is the temperature-scale preference and the chart state.)
    It is not transmitted anywhere.
    If you backup your device to iCloud, the data will be copied there, but is still only accessible to you.
    """
    }

    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {

                    Text("TL;DR: your data is not tracked.")
                        .font(.headline)
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                    Text(privacyExplanation)
                        .modifier(AnswerStyle())

                    Text("No data entered in this application is used for analytics, tracking, or similar activity.")
                        .modifier(AnswerStyle())

                    Text("Data stored in iCloud is governed by:")
                        .modifier(AnswerStyle())

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
