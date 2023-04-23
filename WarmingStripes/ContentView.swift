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
 
 
 view that is simple charts in Swift
 
 check on different sims
 
 Later
 Better color range
 load country data from berkeley site
 
 var screenHeight: CGFloat {
   UIScreen.main.bounds.height
 }
 
 */

import SwiftUI
import UIKit

struct ContentView: View, DeviceSize {
    @EnvironmentObject var model: Model
    @State private var showPreferences = false
    
    //SE and iPhone8 need some padding
    private var padding: CGFloat {
        return isSmallDevice ? 10 : 0
    }

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ChartView(viewModel: ChartViewModel(model: model))
            PreferencesButton(showPreferences: $showPreferences)
                .offset(y: -30)
                .sheet(isPresented: $showPreferences) {
                    PreferencesView()
                }
        }
        .padding(padding)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
