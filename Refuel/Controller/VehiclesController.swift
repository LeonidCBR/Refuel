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
        loadVehicles()
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
    
    private func loadVehicles() {
        PersistentManager.shared.fetchVehicles { (vehicles) in
            self.vehicles = vehicles
        }
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
