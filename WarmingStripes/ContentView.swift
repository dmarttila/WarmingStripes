//
//  ContentView.swift
//  WarmingStripes
//
//  Created by Doug Marttila on 6/21/22.
//
// load data from other site
// clean up branches on repo

import SwiftUI

struct ContentView: View, DeviceInfo {
    @EnvironmentObject var model: Model
    @State private var showPreferences = false

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ChartView(viewModel: ChartViewModel(model: model))
            PreferencesButton(showPreferences: $showPreferences)
                .offset(x: -10, y: -40)
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
