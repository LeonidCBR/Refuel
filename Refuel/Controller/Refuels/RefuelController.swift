//
//  ViewController.swift
//  Refuel
//
//  Created by Яна Латышева on 05.12.2020.
//

import UIKit
import CoreData

protocol RefuelControllerDelegate {
//    func refuelDidSave(_ refuel: CDRefuel, indexPath: IndexPath?)
    func refuelDidSave(_ refuel: CDRefuel)
}

/** Adding or editing a refuel
 */
class RefuelController: ParentController {

    struct RefuelModel {
        var date = Date()
        var liters = 0.0
        var cost = 0.0
        var odometer = 0
    }

    // MARK: - Properties

    private var caption = "Добавить заправку"
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    private var refuelModel = RefuelModel()
//    private var date = Date()
//    private var liters = 0.0
//    private var cost = 0.0
//    private var odometer = 0

    private var rowDatePickerHeight: CGFloat {
        // row heigth equals width of main view
        return view.frame.width
    }
    
    private var datePickerCurrentHeight: CGFloat = 0.0
    
    var delegate: RefuelControllerDelegate?
    
    /** The `editableRefuel` refer to the editing refuel's record.
     If a new refuel's record is created then the `editableRefuel` will be nil.
    */
    var editableRefuel: CDRefuel? {
        didSet {
            guard let refuel = editableRefuel else { return }

            caption = "Изменить данные"
//            date = refuel.date ?? Date()
//            liters = refuel.liters
//            cost = refuel.cost
//            odometer = Int(refuel.odometer)

            refuelModel.date = refuel.date ?? Date()
            refuelModel.liters = refuel.liters
            refuelModel.cost = refuel.cost
            refuelModel.odometer = Int(refuel.odometer)

//            setDate(to: refuel.date)
//            setLiters(to: refuel.liters)
//            setCost(to: refuel.cost)
//            setOdometer(to: Int(refuel.odometer))

        }
    }
    
    /** The `indexPath` refer to the editing refuel's row
     into the table of the refuels controller.
     If a new refuel's record is created then the `indexPath` will be nil.
    */
//    var indexPath: IndexPath?
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    // MARK: - Methods
    
    private func configureUI() {
        title = caption
        
        tableView.separatorStyle = .none
        
        tableView.register(LabelsCell.self,
                           forCellReuseIdentifier: K.Identifier.GeneralCells.labelsCell)
        tableView.register(DatePickerCell.self,
                           forCellReuseIdentifier: K.Identifier.GeneralCells.datePickerCell)
        tableView.register(InputTextCell.self,
                           forCellReuseIdentifier: K.Identifier.GeneralCells.inputTextCell)
        tableView.register(ButtonCell.self,
                           forCellReuseIdentifier: K.Identifier.GeneralCells.buttonCell)

    }

//    private func getString(from doubleValue: Double) -> String {
//        let number = NSNumber(value: doubleValue)
//        let numberFormatter = NumberFormatter()
//        numberFormatter.allowsFloats = true
//        numberFormatter.numberStyle = .decimal
//        return numberFormatter.string(from: number) ?? "0"
//    }

//    private func setDate(to date: Date?) {
//        let indexPath = IndexPath(row: AddRefuelOption.dateLabel.rawValue, section: 0)
//        let cell = tableView.cellForRow(at: indexPath) as! LabelsCell
//        cell.setTextValueLabel(to: Date.getString(of: date))
//    }

    private func setLiters(to value: Double) {
        let indexPath = IndexPath(row: AddRefuelOption.litersAmount.rawValue, section: 0)
        let cell = tableView.cellForRow(at: indexPath) as! InputTextCell
        cell.textField.text = value.toString() //getString(from: value)
    }

    private func setCost(to value: Double) {
        let indexPath = IndexPath(row: AddRefuelOption.cost.rawValue, section: 0)
        let cell = tableView.cellForRow(at: indexPath) as! InputTextCell
        cell.textField.text = value.toString() //getString(from: value)
    }

    private func setOdometer(to value: Int) {
        let indexPath = IndexPath(row: AddRefuelOption.odometer.rawValue, section: 0)
        let cell = tableView.cellForRow(at: indexPath) as! InputTextCell
        cell.textField.text = String(value)
    }

/*
    private func getDate() -> Date {
        let indexPath = IndexPath(row: AddRefuelOption.datePicker.rawValue, section: 0)
        let cell = tableView.cellForRow(at: indexPath) as! DatePickerCell
        return cell.getDate()
    }

    private func getLiters() -> Double {
        let indexPath = IndexPath(row: AddRefuelOption.litersAmount.rawValue, section: 0)
        let cell = tableView.cellForRow(at: indexPath) as! InputTextCell
        return Double(cell.textField.text!)!
//        let number = NumberFormatter().number(from: cell.textField.text!)!
//        return number.doubleValue
    }

    private func getCost() -> Double {
        let indexPath = IndexPath(row: AddRefuelOption.cost.rawValue, section: 0)
        let cell = tableView.cellForRow(at: indexPath) as! InputTextCell
        return Double(cell.textField.text!)!
    }

    private func getOdometer() -> Int {
        let indexPath = IndexPath(row: AddRefuelOption.odometer.rawValue, section: 0)
        let cell = tableView.cellForRow(at: indexPath) as! InputTextCell
        return Int(cell.textField.text!)!
    }
*/
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AddRefuelOption.allCases.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell
        
        let cellOption = AddRefuelOption(rawValue: indexPath.row)!
        
        switch cellOption {
        case .dateLabel:
            let labelsCell = tableView.dequeueReusableCell(withIdentifier: K.Identifier.GeneralCells.labelsCell, for: indexPath) as! LabelsCell
//            labelsCell.setDate(to: date)
            labelsCell.setTextCaptionLabel(to: cellOption.description)
            labelsCell.setTextValueLabel(to: refuelModel.date.toString())
            cell = labelsCell
            
        case .datePicker:
            let datePickerCell = tableView.dequeueReusableCell(withIdentifier: K.Identifier.GeneralCells.datePickerCell, for: indexPath) as! DatePickerCell
            datePickerCell.delegate = self
            datePickerCell.setDate(to: refuelModel.date)
            cell = datePickerCell
            
        case .litersAmount:
            let inputTextCell = tableView.dequeueReusableCell(withIdentifier: K.Identifier.GeneralCells.inputTextCell, for: indexPath) as! InputTextCell
            inputTextCell.delegate = self

            //inputTextCell.option = .litersAmount
//            inputTextCell.tag = AddRefuelOption.litersAmount.rawValue

            inputTextCell.setTextCaptionLabel(to: cellOption.description)
//            inputTextCell.setTextValue(to: getString(from: refuelModel.liters))
            inputTextCell.textField.keyboardType = .decimalPad
            inputTextCell.textField.text = refuelModel.liters.toString()
            cell = inputTextCell
            
        case .cost:
            let inputTextCell = tableView.dequeueReusableCell(withIdentifier: K.Identifier.GeneralCells.inputTextCell, for: indexPath) as! InputTextCell
            inputTextCell.delegate = self

//            inputTextCell.option = .cost
//            inputTextCell.tag = AddRefuelOption.cost.rawValue

            inputTextCell.setTextCaptionLabel(to: cellOption.description)
//            inputTextCell.setTextValue(to: getString(from: cost))
            inputTextCell.textField.keyboardType = .decimalPad
            inputTextCell.textField.text = refuelModel.cost.toString()
            cell = inputTextCell
            
        case .odometer:
            let inputTextCell = tableView.dequeueReusableCell(withIdentifier: K.Identifier.GeneralCells.inputTextCell, for: indexPath) as! InputTextCell
            inputTextCell.delegate = self

//            inputTextCell.option = .odometer
//            inputTextCell.tag = AddRefuelOption.odometer.rawValue

            inputTextCell.setTextCaptionLabel(to: cellOption.description)
//            inputTextCell.setTextValue(to: "\(odometer)")
            inputTextCell.textField.keyboardType = .numberPad
            inputTextCell.textField.text = String(refuelModel.odometer)
            cell = inputTextCell
            
        case .save:
            cell = tableView.dequeueReusableCell(withIdentifier: K.Identifier.GeneralCells.buttonCell, for: indexPath)
            (cell as! ButtonCell).delegate = self
        }

        cell.tag = indexPath.row
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let cellOption = AddRefuelOption(rawValue: indexPath.row), cellOption == .datePicker {
            return datePickerCurrentHeight
        } else {
//            return K.defaultRowHeight
            return tableView.estimatedRowHeight
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


// MARK: - DatePickerCellDelegate

extension RefuelController: DatePickerCellDelegate {
    
    func dateChanged(to date: Date) {
        // We got the date value from cell with date picker
        // And now let's assing it to date label and update model
        let cell = tableView.cellForRow(at: IndexPath(row: AddRefuelOption.dateLabel.rawValue, section: 0)) as! LabelsCell
//            cell.setDate(to: date)
        cell.setTextValueLabel(to: date.toString())

//        self.date = date
        refuelModel.date = date
    }
    
}


// MARK: - InputTextCellDelegate

extension RefuelController: InputTextCellDelegate {

    func didGetValue(_ textField: UITextField, tableViewCell: UITableViewCell) {
        guard let option = AddRefuelOption(rawValue: tableViewCell.tag) else { return }

        guard let text = textField.text,
              let value = Double(from: text)
              //let number = NumberFormatter().number(from: text)
        else {


            // TODO: - Fix bug!
            // if the value has space like "1 000,45" it won't be converted

            
            // Got wrong value. Set old values back to the text field
            if .litersAmount == option { setLiters(to: refuelModel.liters) }
            else if .cost == option { setCost(to: refuelModel.cost) }
            else if .odometer == option { setOdometer(to: refuelModel.odometer) }
            return
        }

        switch option {
        case .litersAmount: refuelModel.liters = value // number.doubleValue
        case .cost: refuelModel.cost = value // number.doubleValue
        case .odometer: refuelModel.odometer = Int(value) // number.intValue
        default:
            fatalError("Wrong TAG!")
        }
    }

/*
    func didGetLiters(_ liters: Double?) {
        guard let liters = liters else {
            // TODO: Show error
            print("DEBUG: show error! wrong liters!")
            
            // Set old values back to the text field
            if let cell = tableView.cellForRow(at: IndexPath(row: AddRefuelOption.litersAmount.rawValue, section: 0)) as? InputTextCell {
                cell.setTextValue(to: getString(from: self.liters))
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
            if let cell = tableView.cellForRow(at: IndexPath(row: AddRefuelOption.cost.rawValue, section: 0)) as? InputTextCell {
                cell.setTextValue(to: getString(from: self.cost))
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
            if let cell = tableView.cellForRow(at: IndexPath(row: AddRefuelOption.odometer.rawValue, section: 0)) as? InputTextCell {
                cell.setTextValue(to: "\(self.odometer)")
            }
            return
        }
        self.odometer = odometer
    }
*/
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
        
//        refuel.date = date
//        refuel.liters = liters
//        refuel.cost = cost
//        refuel.odometer = Int64(odometer)
        
        refuel.date = refuelModel.date
        refuel.liters = refuelModel.liters
        refuel.cost = refuelModel.cost
        refuel.odometer = Int64(refuelModel.odometer)


//        refuel.date = getDate()
//        refuel.liters = getLiters()
//        refuel.cost = getCost()
//        refuel.odometer = Int64(getOdometer())

        do {
            if context.hasChanges {
                try context.save()
            }
            
//            delegate?.refuelDidSave(refuel, indexPath: indexPath)
            delegate?.refuelDidSave(refuel)
            
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
