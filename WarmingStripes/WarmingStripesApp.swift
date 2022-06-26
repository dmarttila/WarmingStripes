//
//  WarmingStripesApp.swift
//  WarmingStripes
//
//  Created by Douglas Marttila on 6/21/22.
//

import SwiftUI

@main
struct WarmingStripesApp: App {
    @StateObject var model = Model()

    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(model)
                .preferredColorScheme(.dark)
        }
    }
}
