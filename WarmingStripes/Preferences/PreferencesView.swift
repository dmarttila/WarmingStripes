//
//  PreferencesView.swift
//  IntermittentFasting
//
//  Created by Doug Marttila on 9/22/21.
//

import SwiftUI
import UniformTypeIdentifiers

struct PreferencesView: View, Haptics {
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var fastingDays: FastingDays
    
    @State var units = WeightUnit.pounds
    
    func thePickerHasChanged (value: WeightUnit) {
        hapticSelectionChange()
        fastingDays.preferences.units = units
    }
    
    func loaded () {
        units = fastingDays.preferences.units
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section (header: Text("About")) {
                        NavigationLink(destination: AboutView()) {
                            Text(Preferences.appTitle)
                        }
                        .listRowBackground(Color.lightestClr)
                        NavigationLink(destination: PrivacyView()) {
                            Text("Privacy")
                        }
                        .listRowBackground(Color.lightestClr)
                        NavigationLink(destination: ImportExportView()) {
                            Text("Import, Export Data")
                        }
                        .listRowBackground(Color.lightestClr)
                    }
                    Section (header: Text("Units")) {
                        Picker("Units:", selection: $units) {
                            ForEach(WeightUnit.allCases) { unit in
                                Text(unit.rawValue)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .listRowBackground(Color.lightestClr)
                        .onChange(of: units, perform: thePickerHasChanged)
                    }
                    #if DEBUG
                    Button("Load Doug Data") {
                        fastingDays.loadDougData()
                    }
                    #endif
                }
            }
            .foregroundColor(.darkestClr)
            .navigationTitle("Preferences")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done"){
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .onAppear(perform: loaded)
        }
    }
    
    struct PreferencesView_Previews: PreviewProvider {
        static var previews: some View {
            PreferencesView()
                .previewDevice("iPhone 12")
                .environmentObject(FastingDays())
        }
    }
}
