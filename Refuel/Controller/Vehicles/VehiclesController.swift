//
//  VehiclesController.swift
//  Refuel
//
//  Created by Яна Латышева on 06.01.2021.
//

import UIKit
import CoreData

class VehiclesController: ParentController {
    
    // MARK: - Properties
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var vehicles: [CDVehicle]?
    var isSelectingMode = false
    var caption = "Транспорт"
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchVehicles()
    }
    
    
    // MARK: - Methods
    
    private func configureUI() {
        title = caption

        if isSelectingMode {
            view.backgroundColor = .systemBlue
        }
        
        if shouldObserveVehicle {
            let plusBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addVehicle))
            navigationItem.rightBarButtonItems?.append(plusBarButtonItem)
        }
        
        tableView.register(VehicleCell.self, forCellReuseIdentifier: K.Identifier.Vehicles.vehicleCell)
    }
    
    private func getNewVehicleController() -> VehicleController {
        let vehicleController = VehicleController()
        vehicleController.shouldTapRecognizer = true
        vehicleController.shouldObserveVehicle = false
        vehicleController.delegate = self
        return vehicleController
    }
    
    private func showChoosingVehiclesController() {
        let choiceController = VehiclesController()
        choiceController.isSelectingMode = true
        choiceController.shouldObserveVehicle = false
        choiceController.caption = "Выберите новое ТС"
        let navController = UINavigationController(rootViewController: choiceController)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true, completion: nil)
    }
    
    
    // MARK: - Selectors
    
    @objc private func fetchVehicles() {
        // TODO: - Show message if an error is received
        let request: NSFetchRequest<CDVehicle> = CDVehicle.fetchRequest()
        do {
            vehicles = try context.fetch(request)
        } catch {
            // TODO: catch errors
            let nserror = error as NSError
            fatalError("DEBUG: Unresolved error \(nserror), \(nserror.userInfo)")
        }
        tableView.reloadData()
    }
    
    @objc private func addVehicle() {
        let newVehicleController = getNewVehicleController()
        navigationController?.pushViewController(newVehicleController, animated: true)
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vehicles?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.Identifier.Vehicles.vehicleCell, for: indexPath) as! VehicleCell
        cell.vehicle = vehicles?[indexPath.row]
        return cell
    }
    
    // Row is selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if isSelectingMode {
            // Select vehicle
            if let vehicle = vehicles?[indexPath.row] {
                VehicleManager.shared.selectedVehicle = vehicle
            }
            dismiss(animated: true, completion: nil)
            
        } else {
            // Edit selected vehicle
            let editingVehicleController = getNewVehicleController()
            editingVehicleController.editableVehicle = vehicles?[indexPath.row]
            navigationController?.pushViewController(editingVehicleController, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            do {
                guard let vehicle = vehicles?[indexPath.row] else { return }
                context.delete(vehicle)
                if context.hasChanges {
                    try context.save()
                }
                vehicles?.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)

                // if the selected vehicle has being deleted
                if let count = vehicles?.count,
                   VehicleManager.shared.selectedVehicle == vehicle {

                    if count == 1 {
                        // Set new selected vehicle to the last one
                        VehicleManager.shared.selectedVehicle = vehicles?.first

                    } else if count == 0 {
                        // The last vehicle has been deleted.
                        // Show controller to create a new one.
                        PresenterManager.shared.showViewController(.createVehicleController)

                    } else {

                        showChoosingVehiclesController()
                    }
                }

            } catch {
                // TODO: catch errors
                let nserror = error as NSError
                fatalError("DEBUG: Unresolved error \(nserror), \(nserror.userInfo)")
            }
            
        }
    }

}


// MARK: - CreateVehicleControllerDelegate

extension VehiclesController: VehicleControllerDelegate {
    func vehicleDidSave(_ vehicle: CDVehicle) {
        fetchVehicles()
    }
}
