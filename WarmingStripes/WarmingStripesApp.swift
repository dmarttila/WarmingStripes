//
//  WarmingStripesApp.swift
//  WarmingStripes
//
//  Created by Doug Marttila on 6/21/22.
//

import SwiftUI

@main
struct WarmingStripesApp: App {

    @StateObject var model = Model()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)
                .environmentObject(model)
        }
    }
}
