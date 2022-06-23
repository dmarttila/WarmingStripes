//
//  Model.swift
//  WarmingStripes
//
//  Created by Douglas Marttila on 6/22/22.
//

import Foundation

final class Model: ObservableObject{
    init () {
        anomalies = loadData()
        print(anomalies)
    }
    @Published var anomalies: [TemperatureAnomaly] = []

    func loadData () ->  [TemperatureAnomaly] {
        var anomalies: [TemperatureAnomaly] = []
        if let filepath = Bundle.main.path(forResource: "HadCRUT.5.0.1.0.summary_series.global.annual", ofType: "csv") {
            do {
                let contents = try String(contentsOfFile: filepath)
                let data = contents.components(separatedBy: "\n")
                for datum in data {
                    let values = datum.components(separatedBy: ",")
                    if let year = Int(values[0]), let tempDiff = Double(values[1]) {
                        anomalies.append(TemperatureAnomaly(year: year, anomaly: tempDiff))
                    }
                }

            } catch {
                // contents could not be loaded
            }
        } else {
            // example.txt not found!
        }
        return anomalies
    }
}

struct TemperatureAnomaly {
    //TODO: Change to dates rather than int
    let year: Int
    let anomaly: Double
}
//    func loadDougData () {
//        let str = DougData.dougData
//        let data = str.components(separatedBy: "\n")
//
//        for day in data {
//            let d = day.components(separatedBy: ",")
//            let weight = Double(d[2])!
//            let type = d[3] == "fasting" ? FastingDayType.fasting : FastingDayType.intermittent
//            let mdy = d[0].components(separatedBy: "/")
//            let year = 2000 + Int(mdy[2])!
//            let month = Int(mdy[0])!
//            let day = Int(mdy[1])!
//            let date = Date(year: year, month: month, day: day)
//            let fd = FastingDay(date: date, dayType: type, weight: weight, units: preferences.units)
//            addOrUpdateADay(fd, saveAndSort: false)
//        }
//        sortDays()
//        saveDays()
//    }
//
//    // let fastingCSV = "2021/11/29 00:00:00,215.4,Pounds,2021/11/29 12:00:00,2021/11/29 20:00:00,Fasting"
//    init (csvFormat: String) throws {
//        let array = csvFormat.components(separatedBy: ",")
//        if array.count != 6 { throw FastingDayCreationError.incorrectParameterCount(array.count) }
//
//        //try to cast each value to the correct type
//        guard let date = Date(csvFormat: array[0]) else { throw FastingDayCreationError.date(array[0]) }
//        guard let dayType = FastingDayType(rawValue: array[1]) else { throw FastingDayCreationError.dayType (array[1]) }
//        guard let weight = Double(array[2]) else { throw FastingDayCreationError.weight(array[2]) }
//        guard let start = Date(csvFormat: array[3]) else { throw FastingDayCreationError.eatingStart (array[3]) }
//        guard let end = Date(csvFormat: (array[4])) else { throw FastingDayCreationError.eatingEnd (array[4]) }
//        guard let units = WeightUnit(rawValue: array[5]) else { throw FastingDayCreationError.units (array[5]) }
//
//        //parameters are valid, create the FastingDay
//        self.init(date: date, dayType: dayType, weight: weight, eatingStart: start, eatingEnd: end, units: units)
//    }



