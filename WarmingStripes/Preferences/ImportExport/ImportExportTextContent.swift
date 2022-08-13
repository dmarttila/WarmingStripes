//
//  ImportExportTextContent.swift
//  IntermittentFasting
//
//  Created by Doug Marttila on 12/2/21.
//

//  Moving content to a separate file so ImportExportView is a bit easier to work on

import Foundation

struct ImportExportContent {
    static let csvSample =
    """
    date,dayType,weight,eatingStart,eatingEnd,units
    2021/12/01 00:00:00,Fasting,50,2021/12/01 12:00:00,2021/12/01 20:00:00,Pounds
    """
    
    static let importDescription1 = """
    You can import data into Fasty from a csv file. Importing data will overwrite days that already exist, but will not necessarily replace all of your data. (E.g., if you load two csv files that have data for different days, data from both csv files will be displayed.) (To replace all your data, delete all your data before loading a csv. Scroll to the bottom of this page for the Delete All Data button.)
    The file needs to be in a specific format, example below...
    """
    
    static let importDescription2 = """
    The first line must be identical to the listed sample.
    Each subsequent line represents one day of data (only one data entry per day).
    If the csv is incorrectly formatted, the data will not import and you will see an error.
    """
    
    static let exportDescription = """
    You can export data from Fasty as a csv file. The file can be saved on your phone or in iCloud.
    Click Export, choose the location where you want to save the file, and click Move.
    """
    
    static let sampleDataDescription = """
    There are sample files that you can load into Fasty. You might want to do this to see how Fasty looks with lots of data. Or maybe you're a friend who offered to test then lost the link to the sample files that I sent you.
    """
    
    static let deleteDataDescription = """
    Clicking the below button will delete all your data. Do you really want to do this? You can't get your data back (unless you've exported it first, and then reload it). Maybe you should export your data before you delete it.
    """
}
