//
//  BundleAndDeviceInfo.swift
//  WarmingStripes
//
//  Created by Doug Marttila on 4/25/23.
//

import UIKit

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

protocol DeviceInfo {
    var isSmallDevice: Bool { get }
    var inLandscapeMode: Bool { get }
}

extension DeviceInfo {
    // true for SE and iPhone 8
    var isSmallDevice: Bool {
        max(UIScreen.main.bounds.height, UIScreen.main.bounds.width) <= 667
    }
    var inLandscapeMode: Bool {
        UIScreen.main.bounds.height < UIScreen.main.bounds.width
    }
}
