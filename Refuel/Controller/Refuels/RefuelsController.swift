//
//  RefuelsController.swift
//  Refuel
//
//  Created by Яна Латышева on 05.12.2020.
//

import UIKit
import CoreData

class RefuelsController: UITableViewController {

    // MARK: - Properties
    var vehicle: CDVehicle? {
        didSet {
            fetchRefuels()
        }
    }
    // didSet fetch refuelsByVehicle
    
    var refuels: [CDRefuel] = [] {
        didSet {
            // TODO: consider to remove it
            tableView.reloadData()
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if vehicle == nil {
            showChoiceController()
        }
    }
    
    
    // MARK: - Methods
    private func configureUI() {
        title = "Заправки"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(selectVehicleButtonTapped))
        
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
        view.backgroundColor = .white
//        tableView.separatorStyle = .none
        tableView.register(RefuelCell.self, forCellReuseIdentifier: K.Identifier.Refuels.refuelCell)
    }
    
    private func fetchRefuels() {
        if let vehicle = vehicle, let refuels = vehicle.refuels?.allObjects as? [CDRefuel] {
            self.refuels = refuels
        }
    }
    
    private func showChoiceController() {
        let choiceController = ChoiceController()
        choiceController.delegate = self
        present(choiceController, animated: true, completion: nil)
    }
    
    
    // MARK: - Selectors
    
    @objc private func selectVehicleButtonTapped() {
        showChoiceController()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return refuels.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.Identifier.Refuels.refuelCell, for: indexPath) as! RefuelCell
        cell.refuel = refuels[indexPath.row]
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

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension RefuelsController: ChoiceControllerDelegate {
    func didChoose(_ vehicle: CDVehicle) {
        self.vehicle = vehicle
        print("selected: \(vehicle.model)")
    }
}
