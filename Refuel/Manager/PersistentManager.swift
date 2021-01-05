//
//  PersistentManager.swift
//  Refuel
//
//  Created by Яна Латышева on 13.12.2020.
//

import UIKit
import CoreData

struct PersistentManager {
    
    // MARK: - Properties
    
    static let shared = PersistentManager()
    private init() {}
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    // MARK: - Methods
    
    func saveVehicle(_ vehicle: Vehicle) {
        print("DEBUG: saving \(vehicle)")
        let newVehicle = CDVehicle(context: context)
        newVehicle.manufacturer = vehicle.manufacturer
        newVehicle.model = vehicle.model
        
        do {
            try context.save()
            
        } catch {
            // TODO: catch errors
            let nserror = error as NSError
            fatalError("DEBUG: Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    func saveRefuel(_ refuel: Refuel) {
        print("DEBUG: saving \(refuel)")
    }
    
    
    func vehiclesExist(completion: (Bool) -> Void) {
        // TODO: return true if vehicles exist
    }
    
    
    func fetchVehicles(completion: @escaping ([CDVehicle]) -> Void) {
        
        let request: NSFetchRequest<CDVehicle> = CDVehicle.fetchRequest()
        do {
            let vehicles = try context.fetch(request)
            completion(vehicles)
        } catch {
            // TODO: catch errors
            let nserror = error as NSError
            fatalError("DEBUG: Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        /*
        print("DEBUG: fetching vehicles...")
        
        let vehicles: [Vehicle] = [Vehicle(manufacturer: "Toyota", model: "Supra"),
                                   Vehicle(manufacturer: "Yamaha", model: "R1")]
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//            completion(vehicles)
            completion([])
        }
        */
        
    }
    
    
    func fetchRefuelsByVehicle(_ vehicle: Vehicle, completion: ([Refuel]) -> Void) {
        
        // TODO: - fetch refuels by vehicle
        
        print("DEBUG: fetching refuels by \(vehicle)")
        
        let refuels: [Refuel] = [Refuel(date: Date(), liters: 25, cost: 1200, odometer: 235000),
                                 Refuel(date: Date(), liters: 10, cost: 500, odometer: 237060),
                                 Refuel(date: Date(), liters: 15.6, cost: 765.3, odometer: 238123)]
        completion(refuels)
    }
}
