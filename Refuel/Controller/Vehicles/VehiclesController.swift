//
//  VehiclesController.swift
//  Refuel
//
//  Created by Яна Латышева on 06.01.2021.
//

import UIKit

class VehiclesController: UITableViewController {
    
    // MARK: - Properties
    
    private var vehicles: [CDVehicle]? //{
        // this is conflicting with remove swipe
//        didSet { tableView.reloadData() }
//    }
    
    //let searchController = UISearchController(searchResultsController: nil)

    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
//        configureSearchController()
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
        
        configureRefreshControl()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: K.Identifier.Vehicles.vehicleCell)

    }
    
    private func configureRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(fetchVehicles), for: .valueChanged)
        self.refreshControl = refreshControl
    }
    
    /*
    private func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search for a user"
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
        } else {
            // Fallback on earlier versions
        }
        definesPresentationContext = false
    }
    */
    
    // MARK: - Selectors
    @objc private func fetchVehicles() {
        PersistentManager.shared.fetchVehicles { (vehicles) in
            self.vehicles = vehicles
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }
    }
    
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
//        if let vehicle = vehicles?[indexPath.row], let manufacturer = vehicle.manufacturer, let model = vehicle.model {
//            cell.textLabel?.text = manufacturer + " " + model
        //        }
        if let manufacturer = vehicles?[indexPath.row].manufacturer, let model = vehicles?[indexPath.row].model {
            cell.textLabel?.text = manufacturer + " " + model
        }
        return cell
    }
    
    // Row is selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let createVehicleController = CreateVehicleController()
        createVehicleController.delegate = self
        createVehicleController.editableVehicle = vehicles?[indexPath.row]
        navigationController?.pushViewController(createVehicleController, animated: true)
    }
    
    /*
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
         if editingStyle == .delete {
             objects.remove(at: indexPath.row)
             tableView.deleteRows(at: [indexPath], with: .fade)
         } else if editingStyle == .insert {
             // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
         }
     }
     */
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            do {
                if let vehicle = vehicles?[indexPath.row] {
                    try PersistentManager.shared.removeVehicle(vehicle)
                    vehicles?.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                } else {
                    print("DEBUG: Vehicle is nil at row \(indexPath.row)!")
                    return
                }
                
            } catch {
                // TODO: catch errors
                let nserror = error as NSError
                fatalError("DEBUG: Unresolved error \(nserror), \(nserror.userInfo)")
            }
//            PersistentManager.shared.deleteVehicle(vehicle) ???
            
        }
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


// MARK: - UISearchResultsUpdating
/*
extension VehiclesController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() else { return }
//        tableView.reloadData()
        filteredUsers = users.filter { $0.username.contains(searchText) ||
            $0.fullname.lowercased().contains(searchText)
        }
    }
}
*/
