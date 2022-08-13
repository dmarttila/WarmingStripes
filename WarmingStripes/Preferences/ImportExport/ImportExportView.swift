//
//  ImportExportView.swift
//  IntermittentFasting
//
//  Created by Doug Marttila on 12/1/21.
//

import SwiftUI
import UniformTypeIdentifiers

struct ImportExportView: View {
    @EnvironmentObject var fastingDays: FastingDays
    
    @State private var document: MessageDocument = MessageDocument(message: "")
    @State private var isImporting: Bool = false
    @State private var isExporting: Bool = false
    
    @State private var alertParams: AlertInfo?
    
    func deleteUsersData () {
        fastingDays.deleteAllData()
        alertParams = AlertInfo(title: "Success", message: "All your base are belong to us!\nActually, all your data was deleted.")
    }
    
    //"1 days" annoys me
    func singlePluralDay (_ dayCount: Int) -> String {
        var str = "\(dayCount) day"
        if dayCount != 1 {
            str += "s"
        }
        return str
    }
    
    func importCSV (csv: String) {
        do {
            let info = try fastingDays.checkCSVFormat(csvFormat: csv)
            //different alerts if data will be overwritten
            var title = "Overwriting Data"
            var message = ""
            var desctructive = true
            if info.overwrite == 0 {
                title = "Loading Data"
                message = "Loading this file will not overwrite any data.\n\(singlePluralDay(info.additions)) will be added to the existing \(singlePluralDay(info.currentCount))."
                desctructive = false
            } else {
                message = "Loading this file will overwrite data.\n\(info.overwrite) out of \(singlePluralDay(info.currentCount)) will be overwritten.\n\(singlePluralDay(info.additions)) will be added."
            }
            alertParams = AlertInfo(title: title, message: message, showTwoButtons: true, primaryButtonLabel: "Load the file", destructive: desctructive) {
                fastingDays.loadFastingDays(info.days)
                alertParams = AlertInfo(title: "Success", message: "Loaded data.")
            }
        }
        catch {
            alertParams = AlertInfo(title: "Error loading file", message: error.localizedDescription)
        }
    }
    
    func exportData () {
        document = MessageDocument(message: fastingDays.csvExport)
        isExporting = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            isExporting = true
        }
    }
    
    var body: some View {
        ZStack {
            Color.lightestClr
                .ignoresSafeArea()
            ScrollView {
                VStack (alignment: .leading){
                    Group {
                        
                        Text("Import")
                            .textStyle(ImportExportHeading())
                        
                        Text(ImportExportContent.importDescription1)
                            .textStyle(AnswerStyle())
                        Text(ImportExportContent.csvSample)
                            .textStyle(CSVDisplay())
                            .padding()
                        Text(ImportExportContent.importDescription2)
                            .textStyle(AnswerStyle())
                        
                        RoundedRectangleButton(label: "Import", systemImage: "square.and.arrow.down", action:
                                                {
                            isImporting = false
                            //Not 100% sure the delay is needed, but this is the working example I found online, and a 0.1 second delay doesn't seem too bad if that is what prevents it from failing on some devices.
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                isImporting = true
                            }
                        }
                        )
                        
                    }
                    Divider()
                    Group {
                        Text("Export")
                            .textStyle(ImportExportHeading())
                        Text(ImportExportContent.exportDescription)
                            .textStyle(AnswerStyle())
                        RoundedRectangleButton(label: "Export", systemImage: "square.and.arrow.up", action: exportData)
                    }
                    Divider()
                    Group {
                        Text("Sample Data")
                            .textStyle(ImportExportHeading())
                        Text(ImportExportContent.sampleDataDescription)
                            .textStyle(AnswerStyle())
                        Link("Fasty Sample Data", destination: URL(string: "https://www.forestandthetrees.com/fasty-mcfastface-test-files/")! )
                    }
                    Divider()
                    Group {
                        Text("Delete")
                            .textStyle(ImportExportHeading())
                        Text(ImportExportContent.deleteDataDescription)
                            .textStyle(AnswerStyle())
                        RoundedRectangleButton(label: "Delete All Data", systemImage: "trash", action:
                                                {
                            alertParams = AlertInfo(title: "OMG! Delete All Data!", message: "This will delete all your data. Are you sure you want to do this? Did you export your data as a csv file?\n\nThere won't be another warning.", showTwoButtons: true, primaryButtonLabel: "Delete All Data", destructive: true, primaryButtonAction: deleteUsersData)
                        }
                        )
                    }
                }
                .navigationTitle("Import, Export")
                .padding()
            }
            .fileExporter(
                isPresented: $isExporting,
                document: document,
                contentType: .commaSeparatedText,
                defaultFilename: "FastyData"
            ) { result in
                if case .success = result {
                    alertParams = AlertInfo(title: "Success", message: "The file was exported.")
                } else {
                    alertParams = AlertInfo(title: "Export failed", message: "The file wasn't exported.")
                }
            }
            .fileImporter(
                isPresented: $isImporting,
                allowedContentTypes: [UTType.commaSeparatedText],
                allowsMultipleSelection: false
            ) { result in
                do {
                    guard let selectedFile: URL = try result.get().first else { return }
                    
                    //trying to get access to url contents
                    if (CFURLStartAccessingSecurityScopedResource(selectedFile as CFURL)) {
                        guard let loadedCSV = String(data: try Data(contentsOf: selectedFile), encoding: .utf8) else { return }
                        //done accessing the url
                        CFURLStopAccessingSecurityScopedResource(selectedFile as CFURL)
                        importCSV(csv: loadedCSV)
                    }
                    else {
                        alertParams = AlertInfo(title: "Permission error", message: "There's been an error accessing the file.")
                    }
                } catch {
                    alertParams = AlertInfo(title: "Error loading file", message: error.localizedDescription)
                }
            }
            .alert(item: $alertParams, content: { alertInfo in
                if alertInfo.showTwoButtons {
                    if alertInfo.destructive {
                        return Alert(
                            title: Text(alertInfo.title),
                            message: Text(alertInfo.message),
                            primaryButton: .destructive(Text(alertInfo.primaryButtonLabel),
                                action: {
                                    alertInfo.primaryButtonAction()
                                })
                            ,
                            secondaryButton: .cancel(Text("Cancel"))
                        )
                    } else {
                        //the only difference between this and the above Alert is .default instead of .desctructive for the primary button label. I can't figure out a way to change that programmatically
                        return Alert(
                            title: Text(alertInfo.title),
                            message: Text(alertInfo.message),
                            primaryButton:
                                    .default(Text(alertInfo.primaryButtonLabel),
                                    action: {
                                        alertInfo.primaryButtonAction()
                                    })
                            ,
                            secondaryButton: .cancel(Text("Cancel"))
                        )
                    }
                } else {
                    return Alert(
                        title: Text(alertInfo.title),
                        message: Text(alertInfo.message)
                    )
                }
            })
            
        }
        
    }
}

struct ImportExportView_Previews: PreviewProvider {
    static var previews: some View {
        ImportExportView()
            .environmentObject(FastingDays())
    }
}
