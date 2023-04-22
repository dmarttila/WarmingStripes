//
//  ContentView.swift
//  WarmingStripes
//
//  Created by Doug Marttila on 6/21/22.
//

/*TODO:
 
 Better color range
 
 I'm using the wrong csv
 how did 1.2 become the raise in temps?
 
 get the url of the data from the site
 
 make Anomalies @Published
 DOn't reload data every time just convert between C and F

 make chart view model and chart lineup next to eachother
 
 check imports everywhere
 
 cleanup magic numbers in chart view
 
 */

import SwiftUI

struct ContentView: View, Haptics {
    @EnvironmentObject var model: Model
    @State private var showPreferences = false

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ChartView(viewModel: ChartViewModel(model: model))
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
