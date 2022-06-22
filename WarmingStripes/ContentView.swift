//
//  ContentView.swift
//  WarmingStripes
//
//  Created by Douglas Marttila on 6/21/22.
//

import SwiftUI

struct ContentView: View {

    //HadCRUT.5.0.1.0.summary_series.global.annual.csv



    init() {
        let model = Model()
    }

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


