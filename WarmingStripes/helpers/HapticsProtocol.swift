//
//  HapticsProtocol.swift
//  HapticTests
//
//  Created by Doug Marttila on 9/20/21.
//
//

import UIKit

//All the standard iOS haptics: https://developer.apple.com/documentation/uikit/uifeedbackgenerator
//iOS provides the following standard iOS haptics
//    error, success, warning, impactLight, impactMedium, impactHeavy, impactRigid, impactSoft, selectionChange

protocol Haptics {
    func hapticError() -> Void
    func hapticSelectionChange() -> Void
    func hapticTap() -> Void
    func hapticSave() -> Void
}
extension Haptics {
    func hapticTap() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }
    func hapticSave() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    func hapticError() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }
    
    func hapticSelectionChange() {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }
}

