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
        static let addRefuel = "Add"
        static let vehicles = "Vehicles"
        static let refuels = "Refuels"
        static let services = "Services"
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
