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
        }
    }

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewControllers()
    }
    

    // MARK: - Methods
    
    private func configureViewControllers() {
        let addRefuelTab = UINavigationController(rootViewController: AddRefuelController())
        let refuelsTab = UINavigationController(rootViewController: RefuelsController())
        let servicesTab = UINavigationController(rootViewController: UIViewController())
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
