//
//  ViewController.swift
//  Refuel
//
//  Created by Яна Латышева on 05.12.2020.
//

import UIKit
import CoreData

protocol RefuelControllerDelegate {
    func refuelDidSave(_ refuel: CDRefuel, indexPath: IndexPath?)
}

class RefuelController: ParentController {

    // MARK: - Properties

    private var caption = "Добавить заправку"
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var date = Date()
    private var liters = 0.0
    private var cost = 0.0
    private var odometer = 0
    
    private var rowDatePickerHeight: CGFloat {
        // row heigth equals width of main view
        return view.frame.width
    }
    
    private var datePickerCurrentHeight: CGFloat = 0
    
    var delegate: RefuelControllerDelegate?
    
    /** The `editableRefuel` refer to the editing refuel's record.
     If a new refuel's record is created then the `editableRefuel` will be nil.
    */
    var editableRefuel: CDRefuel? {
        didSet {
            guard let refuel = editableRefuel else { return }
            caption = "Изменить данные"
            date = refuel.date ?? Date()
            liters = refuel.liters
            cost = refuel.cost
            odometer = Int(refuel.odometer)
        }
    }
    
    /** The `indexPath` refer to the editing refuel's row
     into the table of the refuels controller.
     If a new refuel's record is created then the `indexPath` will be nil.
    */
    var indexPath: IndexPath?
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    // MARK: - Methods
    
    private func configureUI() {
        title = caption
        
        tableView.separatorStyle = .none
        
        tableView.register(ARLabelsCell.self,
                           forCellReuseIdentifier: K.Identifier.AddRefuel.labelsCell)
        tableView.register(ARDatePickerCell.self,
                           forCellReuseIdentifier: K.Identifier.AddRefuel.datePickerCell)
        tableView.register(ARInputTextCell.self,
                           forCellReuseIdentifier: K.Identifier.AddRefuel.inputTextCell)
        tableView.register(ButtonCell.self,
                           forCellReuseIdentifier: K.Identifier.AddRefuel.buttonCell)

    }
    
    private func getString(from doubleValue: Double) -> String {
        let number = NSNumber(value: doubleValue)
        let numberFormatter = NumberFormatter()
        numberFormatter.allowsFloats = true
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: number) ?? "0"
    }
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return AddRefuelOption.allCases.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell
        
        let cellOption = AddRefuelOption(rawValue: indexPath.row)!
        
        switch cellOption {
        case .dateLabel:
            let labelsCell = tableView.dequeueReusableCell(withIdentifier: K.Identifier.AddRefuel.labelsCell, for: indexPath) as! ARLabelsCell
            labelsCell.setDate(to: date)
            cell = labelsCell
            
        case .datePicker:
            let datePickerCell = tableView.dequeueReusableCell(withIdentifier: K.Identifier.AddRefuel.datePickerCell, for: indexPath) as! ARDatePickerCell
            datePickerCell.delegate = self
            datePickerCell.setDate(to: date)
            cell = datePickerCell
            
        case .litersAmount:
            let inputTextCell = tableView.dequeueReusableCell(withIdentifier: K.Identifier.AddRefuel.inputTextCell, for: indexPath) as! ARInputTextCell
            inputTextCell.delegate = self
            inputTextCell.option = .litersAmount
            inputTextCell.setCaption(to: cellOption.caption)
            inputTextCell.setText(to: getString(from: liters))
            cell = inputTextCell
            
        case .cost:
            let inputTextCell = tableView.dequeueReusableCell(withIdentifier: K.Identifier.AddRefuel.inputTextCell, for: indexPath) as! ARInputTextCell
            inputTextCell.delegate = self
            inputTextCell.option = .cost
            inputTextCell.setCaption(to: cellOption.caption)
            inputTextCell.setText(to: getString(from: cost))
            cell = inputTextCell
            
        case .odometer:
            let inputTextCell = tableView.dequeueReusableCell(withIdentifier: K.Identifier.AddRefuel.inputTextCell, for: indexPath) as! ARInputTextCell
            inputTextCell.delegate = self
            inputTextCell.option = .odometer
            inputTextCell.setCaption(to: cellOption.caption)
            inputTextCell.setText(to: "\(odometer)")
            cell = inputTextCell
            
        case .save:
            cell = tableView.dequeueReusableCell(withIdentifier: K.Identifier.AddRefuel.buttonCell, for: indexPath)
            (cell as! ButtonCell).delegate = self
        }
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let cellOption = AddRefuelOption(rawValue: indexPath.row), cellOption == .datePicker {
            return datePickerCurrentHeight
        } else {
            return 60
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cellOption = AddRefuelOption(rawValue: indexPath.row), cellOption == .dateLabel {
            UIView.animate(withDuration: 0.3) {
                // show or hide date picker
                self.datePickerCurrentHeight = self.datePickerCurrentHeight == 0 ? self.rowDatePickerHeight : 0
                tableView.beginUpdates()
                tableView.endUpdates()
            }
        }
    }
    
    /*
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        // remove extra lines from the bottom
        return UIView()
    }
    */
}


// MARK: - ARDatePickerCellDelegate

extension RefuelController: ARDatePickerCellDelegate {
    
    func dateChanged(to date: Date) {
        // We got the date value from cell with date picker
        // And now let's assing it to date label
        if let cell = tableView.cellForRow(at: IndexPath(row: AddRefuelOption.dateLabel.rawValue, section: 0)) as? ARLabelsCell {
            cell.setDate(to: date)
        }
        
        self.date = date
    }
    
}


// MARK: - InputTextCellDelegate

extension RefuelController: ARInputTextCellDelegate {
    
    func didGetLiters(_ liters: Double?) {
        guard let liters = liters else {
            // TODO: Show error
            print("DEBUG: show error! wrong liters!")
            
            // Set old values back to the text field
            if let cell = tableView.cellForRow(at: IndexPath(row: AddRefuelOption.litersAmount.rawValue, section: 0)) as? ARInputTextCell {
                cell.setText(to: getString(from: self.liters))
            }
            return
        }
        self.liters = liters
    }
    
    func didGetCost(_ cost: Double?) {
        guard let cost = cost else {
            // TODO: Show error
            print("DEBUG: show error! wrong cost!")
            
            // Set old values back to the text field
            if let cell = tableView.cellForRow(at: IndexPath(row: AddRefuelOption.cost.rawValue, section: 0)) as? ARInputTextCell {
                cell.setText(to: getString(from: self.cost))
            }
            return
        }
        self.cost = cost
    }
    
    func didGetOdometer(_ odometer: Int?) {
        guard let odometer = odometer else {
            // TODO: Show error
            print("DEBUG: show error! wrong odometer!")
            
            // Set old values back to the text field
            if let cell = tableView.cellForRow(at: IndexPath(row: AddRefuelOption.odometer.rawValue, section: 0)) as? ARInputTextCell {
                cell.setText(to: "\(self.odometer)")
            }
            return
        }
        self.odometer = odometer
    }
    
}


// MARK: - ButtonCellDelegate

extension RefuelController: ButtonCellDelegate {
    
    func saveButtonTapped() {
        let refuel: CDRefuel
        
        if let editableRefuel = editableRefuel {
            refuel = editableRefuel
        } else {
            refuel = CDRefuel(context: context)
            refuel.vehicle = VehicleManager.shared.selectedVehicle
        }
        
        refuel.date = date
        refuel.liters = liters
        refuel.cost = cost
        refuel.odometer = Int64(odometer)
        do {
            if context.hasChanges {
                try context.save()
            }
            
            delegate?.refuelDidSave(refuel, indexPath: indexPath)
            
            if let _ = editableRefuel {
                // Dissmiss this view controller if the selected refuel is edited
                navigationController?.popViewController(animated: true)
                
            } else {
                // Show success message if a new refuel's is created
                PresenterManager.shared.showMessage(withTitle: "Успешно", andMessage: "Данные сохранены", byViewController: self)
            }
        } catch {
            
            // TODO: catch errors, show alarm
            let nserror = error as NSError
            fatalError("DEBUG: Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
}
