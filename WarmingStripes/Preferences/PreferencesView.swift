//
//  PreferencesView.swift
//  WarmingStripes
//
//  Created by Doug Marttila on 8/21/2022.
//

import SwiftUI

struct PreferencesView: View, Haptics, AppBundleInfo {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var model: Model

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("About")) {
                        NavigationLink(destination: AboutView()) {
                            Text(appName)
                        }
                        NavigationLink(destination: PrivacyView()) {
                            Text("Privacy")
                        }
                        NavigationLink(destination: SimpleChartView(viewModel: ChartViewModel(model: model))) {
                            Text("See the data using default Swift Chart settings")
                        }
                        Link("Code available here", destination: URL(string: "https://github.com/dmarttila/WarmingStripes")!)
                    }
                    Section(header: Text("Temperature Scale")) {
                        Picker("Temperature Scale:", selection: $model.temperatureScale) {
                            ForEach(TemperatureScale.allCases) { scale in
                                Text(scale.rawValue)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .onChange(of: model.temperatureScale) { _ in
                            hapticSelectionChange()
                        }
                    }
                }
            }
            .navigationTitle("Preferences")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
    
    struct PreferencesView_Previews: PreviewProvider {
        static var previews: some View {
            PreferencesView()
        }
    }
}
