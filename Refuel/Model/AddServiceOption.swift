//
//  AddServiceOption.swift
//  Refuel
//
//  Created by Яна Латышева on 29.06.2021.
//

import Foundation

enum AddServiceOption: Int, CaseIterable, CustomStringConvertible {
    case selectedVehicle = 0
    case dateLabel
    case datePicker
    case odometer
    case cost
    case text
    case save                   // Save button

    var description: String {
        switch self {
        case .selectedVehicle:  return NSLocalizedString("Vehicle", comment: "")
        case .dateLabel:        return NSLocalizedString("Date", comment: "")
        case .datePicker:       return ""
        case .odometer:         return NSLocalizedString("Odometer", comment: "")
        case .cost:             return NSLocalizedString("Cost", comment: "")
        case .text:             return NSLocalizedString("WhatDone", comment: "")
        case .save:             return ""
        }
    }
}
