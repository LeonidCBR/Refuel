//
//  CreateVehicleOption.swift
//  Refuel
//
//  Created by Яна Латышева on 26.03.2021.
//

import Foundation

enum CreateVehicleOption: Int, CaseIterable {
    case caption = 0
    case manufacturer
    case model
    case save
}


enum InputTextCellOption {
    case manufacturer
    case model
}
