//
//  MainTabBarController.swift
//  Refuel
//
//  Created by Яна Латышева on 05.12.2020.
//

import UIKit
import CoreData

class MainTabBarController: UITabBarController {
    
    // MARK: - Properties
    var selectedVehicle: CDVehicle? {
        didSet {
            print("DEBUG: - Did select vehicle - \(selectedVehicle?.model)")
            NotificationCenter.default.post(name: K.Notification.RFVehicleDidSelect, object: nil)
        }
    }

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewControllers()
    }
    

    // MARK: - Methods
    
    private func configureViewControllers() {
        let addRefuelController = RefuelController()
        let refuelsController = RefuelsController()
        addRefuelController.delegate = refuelsController
        
        let addRefuelTab = UINavigationController(rootViewController: addRefuelController)
        let refuelsTab = UINavigationController(rootViewController: refuelsController)
        let servicesTab = UINavigationController(rootViewController: ServicesController())
        let vehiclesTab = UINavigationController(rootViewController: VehiclesController())
        
        addRefuelTab.tabBarItem = UITabBarItem(title: K.TabBarItem.addRefuel,
                                         image: nil,
                                         tag: 0)
        refuelsTab.tabBarItem = UITabBarItem(title: K.TabBarItem.refuels,
                                         image: nil,
                                         tag: 1)
        servicesTab.tabBarItem = UITabBarItem(title: K.TabBarItem.services,
                                         image: nil,
                                         tag: 2)
        vehiclesTab.tabBarItem = UITabBarItem(title: K.TabBarItem.vehicles,
                                         image: nil,
                                         tag: 3)
        
        viewControllers = [addRefuelTab, refuelsTab, servicesTab, vehiclesTab]
        selectedIndex = 0
    }

}
