//
//  ContentView.swift
//  WarmingStripes
//
//  Created by Doug Marttila on 6/21/22.
//

/*TODO:
 
 maybe bar width should be based on chart geo proxy?
 
 Better color range
 
 For axis show 0.6, 0.3, 0.0, -0.3, -0.6
 
 make all the ranges work for Fehrenheit too
 
 I'm using the wrong csv
 how did 1.2 become the raise in temps?
 
 cahnge copyright to MIT and whatever warming stripes is
 
 make prefs button move based on type of chart chosen
 
 get the url of the data from the site
 
 AppStorage!
 */

import Charts
import SwiftUI

struct ContentView: View, Haptics {
    @EnvironmentObject var model: Model
    @State private var showPreferences = false

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ChartView()
            PreferencesButton(showPreferences: $showPreferences)
                .offset(y: -30)
                .sheet(isPresented: $showPreferences) {
                    PreferencesView().environmentObject(model)
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
