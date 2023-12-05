//
//  CellOption.swift
//  Refuel
//
//  Created by Яна Латышева on 06.12.2020.
//

import Foundation

enum AddRefuelOption: Int, CaseIterable, CustomStringConvertible {
    case dateLabel = 0
    case datePicker
    case litersAmount
    case cost
    case odometer
    case save           // Save button

    var description: String {
        switch self {
        case .dateLabel: return NSLocalizedString("Date", comment: "")
        case .datePicker: return ""
        case .litersAmount: return NSLocalizedString("LitersAmount", comment: "")
        case .cost: return NSLocalizedString("Cost", comment: "")
        case .odometer: return NSLocalizedString("Odometer", comment: "")
        case .save: return ""
        }
    }

}
