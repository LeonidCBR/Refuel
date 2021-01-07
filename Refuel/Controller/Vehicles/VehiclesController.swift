//
//  VehiclesController.swift
//  Refuel
//
//  Created by Яна Латышева on 06.01.2021.
//

import UIKit

class VehiclesController: UITableViewController {
    
    // MARK: - Properties
    
    private var vehicles: [CDVehicle]? {
        didSet { tableView.reloadData() }
    }

    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchVehicles()
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        //navigationItem.rightBarButtonItems
        if #available(iOS 14.0, *) {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addVehicle))
        } else {
            // TODO: - Fallback on earlier versions
        }
    }
    
    
    // MARK: - Methods
    
    private func configureUI() {
        title = "Vehicles"
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
        view.backgroundColor = .white
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: K.Identifier.Vehicles.vehicleCell)
    }
    
    private func fetchVehicles() {
        PersistentManager.shared.fetchVehicles { (vehicles) in
            self.vehicles = vehicles
        }
    }
    
    
    // MARK: - Selectors
    @objc private func addVehicle() {
        let createVehicleController = CreateVehicleController()
        createVehicleController.delegate = self
        navigationController?.pushViewController(createVehicleController, animated: true)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vehicles?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.Identifier.Vehicles.vehicleCell, for: indexPath)
        if let vehicle = vehicles?[indexPath.row], let manufacturer = vehicle.manufacturer, let model = vehicle.model {
            cell.textLabel?.text = manufacturer + " " + model
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let createVehicleController = CreateVehicleController()
        createVehicleController.delegate = self
        createVehicleController.editableVehicle = vehicles?[indexPath.row]
        navigationController?.pushViewController(createVehicleController, animated: true)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */


}


// MARK: - CreateVehicleControllerDelegate

extension VehiclesController: CreateVehicleControllerDelegate {
    
    func didSave() {
        fetchVehicles()
    }
    
}
