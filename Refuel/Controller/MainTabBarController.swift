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
        let addRefuelController = RefuelController()
        let refuelsController = RefuelsController()
        addRefuelController.delegate = refuelsController
        addRefuelController.shouldTapRecognizer = true
        let addRefuelTab = UINavigationController(rootViewController: addRefuelController)
        let refuelsTab = UINavigationController(rootViewController: refuelsController)
        let servicesTab = UINavigationController(rootViewController: ServicesController())
        let vehiclesTab = UINavigationController(rootViewController: VehiclesController())
        addRefuelTab.tabBarItem = UITabBarItem(title: NSLocalizedString("Refill", comment: ""),
                                               image: UIImage(named: "Home"),
                                         tag: 0)
        refuelsTab.tabBarItem = UITabBarItem(title: NSLocalizedString("Refuelings", comment: ""),
                                         image: UIImage(named: "Refuels"),
                                         tag: 1)
        servicesTab.tabBarItem = UITabBarItem(title: NSLocalizedString("Services", comment: ""),
                                         image: UIImage(named: "Services"),
                                         tag: 2)
        vehiclesTab.tabBarItem = UITabBarItem(title: NSLocalizedString("Vehicles", comment: ""),
                                         image: UIImage(named: "Vehicles"),
                                         tag: 3)
        viewControllers = [addRefuelTab, refuelsTab, servicesTab, vehiclesTab]
        selectedIndex = 0
    }

}
