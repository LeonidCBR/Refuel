//
//  VehicleManager.swift
//  Refuel
//
//  Created by Яна Латышева on 27.03.2021.
//

import Foundation

class VehicleManager {

    static let shared = VehicleManager()

    private init() {}

    var selectedVehicle: CDVehicle? {
        didSet {
            NotificationCenter.default.post(name: K.Notification.RFVehicleDidSelect, object: nil)
        }
    }
}
