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
    
    func saveContext() throws {
        
        // (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
        
        if context.hasChanges {
            try context.save()
        }
    }
    
    func saveVehicle(_ vehicle: Vehicle) throws {
        print("DEBUG: saving \(vehicle)")
        let newVehicle = CDVehicle(context: context)
        newVehicle.manufacturer = vehicle.manufacturer
        newVehicle.model = vehicle.model
        
        try context.save()
//        do {
//            try context.save()
//
//        } catch {
//            // TODO: catch errors
//            let nserror = error as NSError
//            fatalError("DEBUG: Unresolved error \(nserror), \(nserror.userInfo)")
//        }
    }
    
    func saveRefuel(_ refuel: Refuel) {
        print("DEBUG: saving \(refuel)")
    }
    
    
    func vehiclesExist(completion: (Bool) -> Void) {
        // TODO: return true if vehicles exist
    }
    
    
    func fetchVehicles(completion: @escaping ([CDVehicle]) -> Void) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            let request: NSFetchRequest<CDVehicle> = CDVehicle.fetchRequest()
            do {
                let vehicles = try context.fetch(request)
                DispatchQueue.main.async {
                    completion(vehicles)
                }
                
            } catch {
                
                // TODO: catch errors
                DispatchQueue.main.async {
                    let nserror = error as NSError
                    fatalError("DEBUG: Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        } 
        /*
        print("DEBUG: fetching vehicles...")
       
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
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
