//
//  ContentView.swift
//  WarmingStripes
//
//  Created by Douglas Marttila on 6/21/22.
//

import SwiftUI

struct ContentView: View {


    @EnvironmentObject var model: Model


    init() {
//        let model = Model()
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


