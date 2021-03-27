//
//  ParentNavigationController.swift
//  Refuel
//
//  Created by Яна Латышева on 21.03.2021.
//

import UIKit

class ParentController: UITableViewController {

    // MARK: - Properties
    
    var selectedVehicle: CDVehicle? {
        get {
            return (tabBarController as? MainTabBarController)?.selectedVehicle
        }
        set {
            if let mainController = tabBarController as? MainTabBarController {
                mainController.selectedVehicle = newValue
            } else {
                print("DEBUG: Check the main controller link!")
            }
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        
        NotificationCenter.default.addObserver(self, selector: #selector(vehicleDidSelect), name: K.Notification.RFVehicleDidSelect, object: nil)
    }
    
    
    // MARK: - Methods
    
    private func configure() {
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
        view.backgroundColor = .white
        setLeftBarItem()
    }
    
    private func setLeftBarItem() {
        let modelVehicle = selectedVehicle?.model ?? "Unknown"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: modelVehicle, style: .plain, target: self, action: #selector(handleSelectVehicleButtonTapped))
            //UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(handleSelectVehicleButtonTapped))
    }
    
    
    // MARK: - Selectors
    
    @objc private func handleSelectVehicleButtonTapped() {
        let choiceController = SelectVehicleController()
        choiceController.delegate = self
        present(choiceController, animated: true, completion: nil)
    }

    @objc func vehicleDidSelect() {
        setLeftBarItem()
    }
    
}


// MARK: - ChoiceControllerDelegate

extension ParentController: ChoiceControllerDelegate {
    func didChoose(_ vehicle: CDVehicle) {
        print("DEBUG: \(#function) New selected vehicle is \(vehicle.model)")
        
        selectedVehicle = vehicle
        
    }
}
