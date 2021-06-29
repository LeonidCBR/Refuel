//
//  AddServiceOption.swift
//  Refuel
//
//  Created by Яна Латышева on 29.06.2021.
//

import Foundation

enum AddServiceOption: Int, CaseIterable, CustomStringConvertible {
    case selectedVehicle = 0    // Выбранное ТС
    case dateLabel              // Дата
    case datePicker             // Календарик
    case odometer               // Пробег
    case cost                   // На сумму
    case text                   // Сделанные работы
    case save                   // Кнопка "Сохранить"

    var description: String {
        switch self {
        case .selectedVehicle:  return "ТС"
        case .dateLabel:        return "Дата"
        case .datePicker:       return "Date picker"
        case .odometer:         return "Пробег"
        case .cost:             return "Сумма"
        case .text:             return "Сделанные работы"
        case .save:             return "Сохранить"
        }
    }
}
