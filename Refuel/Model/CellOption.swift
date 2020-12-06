//
//  CellOption.swift
//  Refuel
//
//  Created by Яна Латышева on 06.12.2020.
//

import Foundation

enum CellOption: Int, CaseIterable, CustomStringConvertible {
    
    case dateLabel = 0 // Дата
    case datePicker // Календарик
    case litersAmount // Заправлено литров
    case sum // На сумму
    case odo // Пробег
    case save // Кнопка "Сохранить"
    
    var description: String {
        switch self {
        case .dateLabel: return "Дата"
        case .datePicker: return "Date picker"
        case .litersAmount: return "Заправлено литров"
        case .sum: return "На сумму"
        case .odo: return "Пробег"
        case .save: return "Сохранить"
        }
    }
    
}
