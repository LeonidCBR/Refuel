//
//  CellOption.swift
//  Refuel
//
//  Created by Яна Латышева on 06.12.2020.
//

import Foundation

enum AddRefuelOption: Int, CaseIterable {
    
    case dateLabel = 0 // Дата
    case datePicker // Календарик
    case litersAmount // Заправлено литров
    case cost // На сумму
    case odometer // Пробег
    case save // Кнопка "Сохранить"
    
    var caption: String {
        switch self {
        case .dateLabel: return "Дата"
        case .datePicker: return "Date picker"
        case .litersAmount: return "Заправлено литров"
        case .cost: return "На сумму"
        case .odometer: return "Пробег"
        case .save: return "Сохранить"
        }
    }

}
