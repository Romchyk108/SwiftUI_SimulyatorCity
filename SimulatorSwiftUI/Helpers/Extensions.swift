//
//  Extensions.swift
//  SimulatorSwiftUI
//
//  Created by Roman Shestopal on 25.06.2023.
//

import Foundation

extension Int {
    var scale: String {
        let number = Float(self)
        let thousand = number / 1000
        let million = number / 1000000
        let billion = number / 1000000000
        if billion >= 1.0 {
            return "\(round(billion*10)/10) B"
        } else if million >= 1.0 {
            return "\(round(million*10)/10) M"
        } else if thousand >= 1.0 {
            return self % 1000 > 0 ? ("\(String(format: "%.1f", thousand)) k") : ("\(String(format: "%.0f", thousand)) k")
        } else {
            return "\(self)"
        }
    }
    var scalePower: String {
        let number = Double(self)
        let thousand = number / 1000
        let million = number / 1000000
        let billion = number / 1000000000
        if billion >= 1.0 {
            return ("\(String(format: "%.1f", billion)) TW*h")
        } else if million >= 1.0 {
            return ("\(String(format: "%.1f", million)) GW*h")
        } else if thousand >= 1.0 {
            return ("\(String(format: "%.1f", thousand)) MW*h")
        } else {
            return ("\(String(format: "%.0f", number)) kW*h")
        }
    }
}

extension Double {
    var scale: String {
        let number = self
        let thousand = number / 1000
        let million = number / 1000000
        let billion = number / 1000000000
        if billion >= 1.0 {
            return ("\(String(format: "%.1f", billion)) B")
        } else if million >= 1.0 {
            return ("\(String(format: "%.1f", million)) M")
        } else if thousand >= 1.0 {
            return ("\(String(format: "%.1f", thousand)) k")
        } else {
            return ("\(String(format: "%.0f", number))")
        }
    }
    var scalePower: String {
        let number = self
        let thousand = number / 1000
        let million = number / 1000000
        let billion = number / 1000000000
        if billion >= 1.0 {
            return ("\(String(format: "%.1f", billion)) TW*h")
        } else if million >= 1.0 {
            return ("\(String(format: "%.1f", million)) GW*h")
        } else if thousand >= 1.0 {
            return ("\(String(format: "%.1f", thousand)) MW*h")
        } else {
            return ("\(String(format: "%.0f", number)) kW*h")
        }
    }
    var scaleDate: String {
        let hours = self
        let days = hours / 24
        let weeks = days / 7
        let months = days / 30
        let years = months / 12
        if years >= 1.0 {
            return ("\(String(format: "%.1f", years)) Y")
        } else if months >= 1.0 {
            return ("\(String(format: "%.1f", months)) M")
        } else if weeks >= 1.0 {
            return ("\(String(format: "%.1f", weeks)) w")
        } else if days >= 1.0 {
            return ("\(String(format: "%.1f", days)) d")
        } else {
            return ("\(String(format: "%.0f", hours)) h")
        }
    }
}
