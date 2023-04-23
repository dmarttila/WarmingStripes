//
//  BundleDeviceInfo.swift
//  WarmingStripes
//
//  Created by Doug Marttila on 4/16/23.
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

protocol DeviceSize {
    var isSmallDevice: Bool { get }
}

extension DeviceSize {
    //true for SE and iPhone 8
    var isSmallDevice: Bool {
        let screenSize = max(UIScreen.main.bounds.height, UIScreen.main.bounds.width)
        return screenSize <= 667
    }
}
