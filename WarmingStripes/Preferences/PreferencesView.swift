//
//  PreferencesView.swift
//  IntermittentFasting
//
//  Created by Doug Marttila on 9/22/21.
//

import SwiftUI



struct Preferences: Codable {
    var units: TemperatureUnit = .celsius
    public static var appTitle = "Warming Stripes"
    public static var version = "1.0.0"
}

public enum TemperatureUnit: String, CaseIterable, Identifiable, Codable {
    case celsius = "Celsius"
    case fahrenheit = "Fahrenheit"
    public var id: TemperatureUnit { self }
    public var abbreviation: String {
        if self == .celsius {
            return "°C"
        } else {
            return "°F"
        }
    }
    public static func cToF (_ c: Double) -> Double {
        c * 9/5
    }
}

struct PreferencesView: View, Haptics {
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var model: Model
    
//    @State var units = TemperatureUnit.celsius
    
//   @State var preferences = PreferencesModel()
    
    func thePickerHasChanged (value: TemperatureUnit) {
        hapticSelectionChange()
//        fastingDays.preferences.units = units
        model.preferences.units = value
    }
    
//    func loaded () {
//        units = preferences.units
//    }
    
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
                        
                    }
                    Section (header: Text("Units")) {
                        Picker("Units:", selection: $model.preferences.units) {
                            ForEach(TemperatureUnit.allCases) { unit in
                                Text(unit.rawValue)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .listRowBackground(Color.lightestClr)
                        .onChange(of: model.preferences.units, perform: thePickerHasChanged)
                    }
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
//            .onAppear(perform: loaded)
        }
    }
    
    struct PreferencesView_Previews: PreviewProvider {
        static var previews: some View {
            PreferencesView()
        }
    }
}
