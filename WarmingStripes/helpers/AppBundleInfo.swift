//
//  AppBundleInfo.swift
//  WarmingStripes
//
//  Created by Doug Marttila on 4/16/23.
//

import Foundation

protocol AppBundleInfo {
    var appName: String { get }
    var appVersion: String { get }
}


extension AppBundleInfo {
    var appName: String {
        Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String ?? ""
    }
    var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0.0"
    }
}
