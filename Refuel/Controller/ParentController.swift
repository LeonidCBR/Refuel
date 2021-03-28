//
//  ParentNavigationController.swift
//  Refuel
//
//  Created by Яна Латышева on 21.03.2021.
//

import UIKit

class ParentController: UITableViewController {

    // MARK: - Properties
    var shouldObserveVehicle = true

    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    // MARK: - Methods
    
    private func configure() {
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
        view.backgroundColor = .white
        
        if shouldObserveVehicle {
            
            let modelVehicle = VehicleManager.shared.selectedVehicle?.model ?? "Unknown"
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: modelVehicle, style: .plain, target: self, action: #selector(handleSelectVehicleButtonTapped))
            
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(vehicleDidSelect),
                                                   name: K.Notification.RFVehicleDidSelect,
                                                   object: nil)
        }
        
    }
    
    private func setBarButtonItem() {
        navigationItem.rightBarButtonItem?.title = VehicleManager.shared.selectedVehicle?.model
    }
    
    
    // MARK: - Selectors
    
    @objc private func handleSelectVehicleButtonTapped() {
        
        let choiceController = VehiclesController()
        choiceController.isSelectingMode = true
        choiceController.shouldObserveVehicle = false
        choiceController.caption = "Выберите ТС"
        present(UINavigationController(rootViewController: choiceController), animated: true, completion: nil)
    }

    @objc func vehicleDidSelect() {
        setBarButtonItem()
    }
    
}
