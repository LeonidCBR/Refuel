//
//  Constants.swift
//  Refuel
//
//  Created by Яна Латышева on 05.12.2020.
//

import UIKit

struct K {

    static let defaultRowHeight: CGFloat = 60.0
    
    struct TabBarItem {
        static let addRefuel = "Добавить заправку" //"Add"
        static let vehicles = "Транспорт" //"Vehicles"
        static let refuels = "Заправки" //"Refuels"
        static let services = "Обслуживание" //"Services"
    }
    
    struct Identifier {

        struct AddRefuel {
            static let labelsCell = "addRefuelLabelsIdentifier"
            static let datePickerCell = "addRefuelDatePickerIdentifier"
            static let inputTextCell = "addRefuelInputTextIdentifier"
            static let buttonCell = "addRefuelButtonIdentifier"
        }
        
        struct Refuels {
            static let refuelCell = "refuelIdentifier"
        }

        struct Services {
            static let serviceCell = "serviceIdentifier"
        }
        
        struct Vehicles {
            static let vehicleCell = "vehicleIdentifier"
        }
        
        struct CreateVehicle {
            static let captionCell = "createVehicleCaptionIdentifier"
            static let inputTextCell = "createVehicleInputTextIdentifier"
            static let buttonCell = "createVehicleButtonIdentifier"
        }
    }
    
    struct Notification {
        static let RFVehicleDidSelect = NSNotification.Name(rawValue: "RFVehicleDidSelect")
    }
    
}
