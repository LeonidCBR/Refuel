//
//  MainTabBarController.swift
//  Refuel
//
//  Created by Яна Латышева on 05.12.2020.
//

import UIKit

class MainTabBarController: UITabBarController {

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewControllers()
    }
    

    // MARK: - Methods
    
    private func configureViewControllers() {
        let addRefuelTab = UINavigationController(rootViewController: AddRefuelController())
        let vehiclesTab = UIViewController()
        let refuelsTab = UIViewController()
        let servicesTab = UIViewController()
        
        addRefuelTab.tabBarItem = UITabBarItem(title: K.TabBarItem.addRefuel,
                                         image: nil,
                                         tag: 0)
        vehiclesTab.tabBarItem = UITabBarItem(title: K.TabBarItem.vehicles,
                                         image: nil,
                                         tag: 1)
        refuelsTab.tabBarItem = UITabBarItem(title: K.TabBarItem.refuels,
                                         image: nil,
                                         tag: 2)
        servicesTab.tabBarItem = UITabBarItem(title: K.TabBarItem.services,
                                         image: nil,
                                         tag: 3)
        
        viewControllers = [addRefuelTab, vehiclesTab, refuelsTab, servicesTab]
        selectedIndex = 0
    }

}
