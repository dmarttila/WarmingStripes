//
//  PreferencesView.swift
//  WarmingStripes
//
//  Created by Doug Marttila on 8/21/2022.
//

import SwiftUI

struct PreferencesView: View, Haptics {
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var model: Model
    
    func thePickerHasChanged (value: TemperatureUnit) {
        hapticSelectionChange()
        model.preferences.units = value
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section (header: Text("About")) {
                        NavigationLink(destination: AboutView()) {
                            Text(Preferences.appTitle)
                        }
                        NavigationLink(destination: PrivacyView()) {
                            Text("Privacy")
                        }
                        
                    }
                    Section (header: Text("Units")) {
                        Picker("Units:", selection: $model.preferences.units) {
                            ForEach(TemperatureUnit.allCases) { unit in
                                Text(unit.rawValue)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .onChange(of: model.preferences.units, perform: thePickerHasChanged)
                    }
                }
            }
            .navigationTitle("Preferences")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done"){
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
