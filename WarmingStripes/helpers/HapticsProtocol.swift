//
//  Haptics.swift
//
//  Created by Doug Marttila on 9/20/21.
//
//

import UIKit

protocol Haptics {
    func hapticError() 
    func hapticSelectionChange() 
    func hapticTap() 
    func hapticSave()
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
