//
//  ContentView.swift
//  WarmingStripes
//
//  Created by Doug Marttila on 6/21/22.
//

/*TODO:
 
 view that is simple charts in Swift

 move the preferences button based on the chart state

 the data set doesn't match
 
 Later
 Better color range
 load country data from berkeley site
 
 */

import SwiftUI
import UIKit

struct ContentView: View, DeviceSize {
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
        // SE and iPhone8 need some padding
        .padding(isSmallDevice ? 10 : 0)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
