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
    case save

    var description: String {
        switch self {
        case .selectedVehicle:  return "ТС"
        case .dateLabel:        return "Дата"
        case .datePicker:       return "Date picker"
        case .odometer:         return "Пробег"
        case .cost:             return "Сумма"
        case .text:             return "Проделанные работы"
        case .save:             return "Сохранить"
        }
    }
}
