//
//  ContentView.swift
//  WarmingStripes
//
//  Created by Doug Marttila on 6/21/22.
//

/*TODO:
 
 maybe bar width should be based on chart geo proxy?
 
 Better color range
 
 I'm using the wrong csv
 how did 1.2 become the raise in temps?
 
 cahnge copyright to MIT and whatever warming stripes is
 
 get the url of the data from the site
 
 make Anomalies @Published
 
 Make Binding happen in Preferences
 
 DOn't reload data every time just convert between C and F
 
 AppStorage!
 */

import Charts
import SwiftUI

struct ContentView: View, Haptics {
    @EnvironmentObject var model: Model
    @State private var showPreferences = false

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ChartView(model: model)
            PreferencesButton(showPreferences: $showPreferences)
                .offset(y: -30)
                .sheet(isPresented: $showPreferences) {
                    PreferencesView()
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
