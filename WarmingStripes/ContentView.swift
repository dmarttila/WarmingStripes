//
//  ContentView.swift
//  WarmingStripes
//
//  Created by Doug Marttila on 6/21/22.
//

/*TODO:
 
 
 
 get the url of the data from the site

 make chart view model and chart lineup next to eachother
  
 cleanup magic numbers in chart view
 
 why isn't 2022 showing up - should be from the data set
 
 view that is simple charts in Swift
 
 check on different sims
 
 Later
 Better color range
 load country data from berkeley site
 
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
