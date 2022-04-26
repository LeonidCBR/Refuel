//
//  Constants.swift
//  Refuel
//
//  Created by Яна Латышева on 05.12.2020.
//

import UIKit

struct K {

    struct TabBarItem {
        static let addRefuel = "Добавить заправку"
        static let vehicles = "Транспорт"
        static let refuels = "Заправки"
        static let services = "Обслуживание"
    }
    
    struct Identifier {

        struct GeneralCells {
            static let labelsCell = "labelsCellIdentifier"
            static let datePickerCell = "datePickerCellIdentifier"
            static let inputTextCell = "inputTextCellIdentifier"
            static let multiLineTextCell = "multiLineTextCellIdentifier"
            static let buttonCell = "buttonCellIdentifier"
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
