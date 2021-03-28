//
//  RefuelsController.swift
//  Refuel
//
//  Created by Яна Латышева on 05.12.2020.
//

import UIKit
import CoreData

class RefuelsController: ParentController {

    // MARK: - Properties
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
//    var vehicle: CDVehicle? {
//        didSet {
//            fetchRefuels()
//        }
//    }
    // didSet fetch refuelsByVehicle
    
    var refuels: [CDRefuel]?
    {
        didSet {
            print("DEBUG: - Refuels has been changed")
//            // TODO: consider to remove it
//            tableView.reloadData()
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchRefuels()
    }
    
    // MARK: - Methods
    private func configureUI() {
        title = "Заправки"
        
//        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(selectVehicleButtonTapped))
        
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
        view.backgroundColor = .white
//        tableView.separatorStyle = .none
        tableView.register(RefuelCell.self, forCellReuseIdentifier: K.Identifier.Refuels.refuelCell)
    }
    
    private func fetchRefuels() {
        
        if let refuels = VehicleManager.shared.selectedVehicle?.refuels?.allObjects as? [CDRefuel] {
            self.refuels = refuels
        }
        
//        let request: NSFetchRequest<CDRefuel> = CDRefuel.fetchRequest()
        // TODO: Create predicate where vehicle = selected vehicle
//        refuels = try! context.fetch(request)
        
        tableView.reloadData()
        
//        if let vehicle = vehicle, let refuels = vehicle.refuels?.allObjects as? [CDRefuel] {
//            self.refuels = refuels
//        }
    }

    
    // MARK: - Selectors
    override func vehicleDidSelect() {
        super.vehicleDidSelect()
        fetchRefuels()
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return refuels?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.Identifier.Refuels.refuelCell, for: indexPath) as! RefuelCell
        cell.refuel = refuels?[indexPath.row]
        return cell
    }
    
    // Delete refuel record
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("DEBUG: Delete row \(indexPath.row)")
            
            guard let refuel = refuels?[indexPath.row] else { return }
            context.delete(refuel)
            do {
                if context.hasChanges {
                    try context.save()
                }
                refuels?.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            } catch {
                // TODO: catch errors
                let nserror = error as NSError
                PresenterManager.shared.showMessage(withTitle: "Ошибка!", andMessage: "\(nserror). \(nserror.userInfo)", byViewController: self)
            }
        }
    }
    
    // Select and edit refuel record
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let refuelController = RefuelController()
        refuelController.shouldObserveVehicle = false
        refuelController.delegate = self
        refuelController.indexPath = indexPath
        
        refuelController.editableRefuel = refuels?[indexPath.row]
        navigationController?.pushViewController(refuelController, animated: true)
    }

}


// MARK: - RefuelControllerDelegate

extension RefuelsController: RefuelControllerDelegate {
    
    func refuelDidChange(_ refuel: CDRefuel, indexPath: IndexPath?) {

        guard refuel.vehicle == VehicleManager.shared.selectedVehicle else { return }
        
        if let indexPath = indexPath {
            // Editing refuel's record
            print("DEBUG: - Editing refuel's record")
            tableView.reloadRows(at: [indexPath], with: .none)
            
        } else {
            // New refuel's record
            print("DEBUG: - New refuel's record")
            refuels?.append(refuel)
            let newIndexPath = IndexPath(row: tableView.numberOfRows(inSection: 0), section: 0)
            tableView.insertRows(at: [newIndexPath], with: .none)
        }
        
//        fetchRefuels()
//        tableView.reloadData()

    }
}
