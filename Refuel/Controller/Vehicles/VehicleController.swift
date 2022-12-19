//
//  CreateVehicleController.swift
//  Refuel
//
//  Created by Яна Латышева on 14.12.2020.
//

import UIKit
import CoreData

protocol VehicleControllerDelegate: AnyObject {
    func vehicleDidSave(_ vehicle: CDVehicle)
}

/** Adding or editing a vehicle
 */
class VehicleController: ParentController {
    
    // MARK: - Properties
    private var caption = NSLocalizedString("AddingVehicle", comment: "")
    private var manufacturer = ""
    private var model = ""
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    weak var delegate: VehicleControllerDelegate?
    
    /** The `editableVehicle` refer to the editing vehicle's record.
     If a new vehicle's record is created then the `editableVehicle` will be nil.
    */
    var editableVehicle: CDVehicle? {
        didSet {
            guard let vehicle = editableVehicle else { return }
            caption = NSLocalizedString("EditingVehicle", comment: "")
            manufacturer = vehicle.manufacturer ?? ""
            model = vehicle.model ?? ""
        }
    }


    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    
    // MARK: - Methods
    
    private func configureUI() {
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        
        tableView.register(CVCaptionCell.self,
                           forCellReuseIdentifier: K.Identifier.CreateVehicle.captionCell)
        tableView.register(CVInputTextCell.self,
                           forCellReuseIdentifier: K.Identifier.CreateVehicle.inputTextCell)
        tableView.register(ButtonCell.self,
                           forCellReuseIdentifier: K.Identifier.CreateVehicle.buttonCell)
        
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CreateVehicleOption.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        
        let cellOption = CreateVehicleOption(rawValue: indexPath.row)!
        switch cellOption {
        case .caption:
            let captionCell = tableView.dequeueReusableCell(withIdentifier: K.Identifier.CreateVehicle.captionCell, for: indexPath) as! CVCaptionCell
            captionCell.setCaption(caption)
            cell = captionCell
            
        case .manufacturer:
            let manufacturerCell = tableView.dequeueReusableCell(withIdentifier: K.Identifier.CreateVehicle.inputTextCell, for: indexPath) as! CVInputTextCell
            manufacturerCell.cellOption = .manufacturer
            manufacturerCell.delegate = self
            manufacturerCell.setPlaceholder(NSLocalizedString("Manufacturer", comment: ""))
            manufacturerCell.setText(manufacturer)
            cell = manufacturerCell
            
        case .model:
            let modelCell = tableView.dequeueReusableCell(withIdentifier: K.Identifier.CreateVehicle.inputTextCell, for: indexPath) as! CVInputTextCell
            modelCell.cellOption = .model
            modelCell.delegate = self
            modelCell.setPlaceholder(NSLocalizedString("Model", comment: ""))
            modelCell.setText(model)
            cell = modelCell
            
        case .save:
            let buttonCell = tableView.dequeueReusableCell(withIdentifier: K.Identifier.CreateVehicle.buttonCell, for: indexPath) as! ButtonCell
            buttonCell.delegate = self
            cell = buttonCell
        }
        
        return cell
    }

}


// MARK: - ButtonCellDelegate

extension VehicleController: ButtonCellDelegate {
    
    func saveButtonTapped() {
            if manufacturer.isEmpty {
                PresenterManager.showMessage(withTitle: NSLocalizedString("Error", comment: ""), andMessage: NSLocalizedString("InputManufacturer", comment: ""), byViewController: self)
                return
            }

            if model.isEmpty {
                PresenterManager.showMessage(withTitle: NSLocalizedString("Error", comment: ""), andMessage: NSLocalizedString("InputModel", comment: ""), byViewController: self)
                return
            }
        
        let vehicle: CDVehicle
        if let didEditVehicle = editableVehicle {
            // Editing vehicle
            vehicle = didEditVehicle
        } else {
            // Creating new vehicle
            vehicle = CDVehicle(context: context)
        }
        vehicle.manufacturer = manufacturer
        vehicle.model = model
        
        do {
            if context.hasChanges {
                try context.save()
            }
            
            delegate?.vehicleDidSave(vehicle)
            
            VehicleManager.shared.selectedVehicle = vehicle
            if let navigationController = navigationController {
                navigationController.popViewController(animated: true)
            } else {
                PresenterManager.showViewController(.mainTabBarController)
            }
            
        } catch {

            let nserror = error as NSError
            PresenterManager.showMessage(withTitle: NSLocalizedString("Error", comment: ""), andMessage: "\(NSLocalizedString("DeviceError", comment: "")) \(nserror) \(nserror.userInfo)", byViewController: self)
            context.rollback()
        }
    }
}


// MARK: - CVInputTextCellDelegate
extension VehicleController: CVInputTextCellDelegate {
    func didChangeText(_ inputTextCell: CVInputTextCell, withText text: String) {
        switch inputTextCell.cellOption {
        case .manufacturer:
            manufacturer = text
        case .model:
            model = text
        case .none: break
        }
    }
}
