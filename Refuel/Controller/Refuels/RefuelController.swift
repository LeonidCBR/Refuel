//
//  ViewController.swift
//  Refuel
//
//  Created by Яна Латышева on 05.12.2020.
//

import UIKit
import CoreData

protocol RefuelControllerDelegate: AnyObject {
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

    private var caption = NSLocalizedString("Refill", comment: "")
    // swiftlint:disable force_cast
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    // swiftlint:enable force_cast
    private var refuelModel = RefuelModel()

    private var rowDatePickerHeight: CGFloat {
        // row heigth equals width of main view
        return view.frame.width
    }

    private var datePickerCurrentHeight: CGFloat = 0.0

    weak var delegate: RefuelControllerDelegate?

    /** The `editableRefuel` refer to the editing refuel's record.
     If a new refuel's record is created then the `editableRefuel` will be nil.
    */
    var editableRefuel: CDRefuel? {
        didSet {
            guard let refuel = editableRefuel else { return }

            caption = NSLocalizedString("EditData", comment: "")
            refuelModel.date = refuel.date ?? Date()
            refuelModel.liters = refuel.liters
            refuelModel.cost = refuel.cost
            refuelModel.odometer = Int(refuel.odometer)
        }
    }

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
                           forCellReuseIdentifier: CellIdentifiers.GeneralCells.labelsCell)
        tableView.register(DatePickerCell.self,
                           forCellReuseIdentifier: CellIdentifiers.GeneralCells.datePickerCell)
        tableView.register(InputTextCell.self,
                           forCellReuseIdentifier: CellIdentifiers.GeneralCells.inputTextCell)
        tableView.register(ButtonCell.self,
                           forCellReuseIdentifier: CellIdentifiers.GeneralCells.buttonCell)
    }

    private func setLiters(to value: Double) {
        let indexPath = IndexPath(row: AddRefuelOption.litersAmount.rawValue, section: 0)
        if let cell = tableView.cellForRow(at: indexPath) as? InputTextCell {
            cell.textField.text = value.toString()
        }
    }

    private func setCost(to value: Double) {
        let indexPath = IndexPath(row: AddRefuelOption.cost.rawValue, section: 0)
        if let cell = tableView.cellForRow(at: indexPath) as? InputTextCell {
            cell.textField.text = value.toString()
        }
    }

    private func setOdometer(to value: Int) {
        let indexPath = IndexPath(row: AddRefuelOption.odometer.rawValue, section: 0)
        if let cell = tableView.cellForRow(at: indexPath) as? InputTextCell {
            cell.textField.text = String(value)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AddRefuelOption.allCases.count
    }

    // TODO: This method should be refactored
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        guard let cellOption = AddRefuelOption(rawValue: indexPath.row) else {
            return UITableViewCell()
        }
        switch cellOption {
        case .dateLabel:
            guard let labelsCell = tableView.dequeueReusableCell(
                withIdentifier: CellIdentifiers.GeneralCells.labelsCell,
                for: indexPath) as? LabelsCell else {
                return UITableViewCell()
            }
            labelsCell.setTextCaptionLabel(to: cellOption.description)
            labelsCell.setTextValueLabel(to: refuelModel.date.toString())
            cell = labelsCell
        case .datePicker:
            guard let datePickerCell = tableView.dequeueReusableCell(
                withIdentifier: CellIdentifiers.GeneralCells.datePickerCell,
                for: indexPath) as? DatePickerCell else {
                return UITableViewCell()
            }
            datePickerCell.delegate = self
            datePickerCell.setDate(to: refuelModel.date)
            cell = datePickerCell
        case .litersAmount:
            guard let inputTextCell = tableView.dequeueReusableCell(
                withIdentifier: CellIdentifiers.GeneralCells.inputTextCell,
                for: indexPath) as? InputTextCell else {
                return UITableViewCell()
            }
            inputTextCell.delegate = self
            inputTextCell.setTextCaptionLabel(to: cellOption.description)
            inputTextCell.textField.keyboardType = .decimalPad
            inputTextCell.textField.text = refuelModel.liters.toString()
            cell = inputTextCell
        case .cost:
            guard let inputTextCell = tableView.dequeueReusableCell(
                withIdentifier: CellIdentifiers.GeneralCells.inputTextCell,
                for: indexPath) as? InputTextCell else {
                return UITableViewCell()
            }
            inputTextCell.delegate = self
            inputTextCell.setTextCaptionLabel(to: cellOption.description)
            inputTextCell.textField.keyboardType = .decimalPad
            inputTextCell.textField.text = refuelModel.cost.toString()
            cell = inputTextCell
        case .odometer:
            guard let inputTextCell = tableView.dequeueReusableCell(
                withIdentifier: CellIdentifiers.GeneralCells.inputTextCell,
                for: indexPath) as? InputTextCell else {
                return UITableViewCell()
            }
            inputTextCell.delegate = self
            inputTextCell.setTextCaptionLabel(to: cellOption.description)
            inputTextCell.textField.keyboardType = .numberPad
            inputTextCell.textField.text = String(refuelModel.odometer)
            cell = inputTextCell
        case .save:
            guard let buttonCell = tableView.dequeueReusableCell(
                withIdentifier: CellIdentifiers.GeneralCells.buttonCell,
                for: indexPath) as? ButtonCell else {
                return UITableViewCell()
            }
            buttonCell.delegate = self
            cell = buttonCell
        }
        cell.tag = indexPath.row
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let cellOption = AddRefuelOption(rawValue: indexPath.row), cellOption == .datePicker {
            return datePickerCurrentHeight
        } else {
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
}

// MARK: - DatePickerCellDelegate

extension RefuelController: DatePickerCellDelegate {

    func dateChanged(to date: Date) {
        // We got the date value from cell with date picker
        // And now let's assing it to date label and update model
        guard let cell = tableView.cellForRow(at: IndexPath(row: AddRefuelOption.dateLabel.rawValue,
                                                            section: 0)) as? LabelsCell else {
            return
        }
        cell.setTextValueLabel(to: date.toString())
        refuelModel.date = date
    }
}

// MARK: - InputTextCellDelegate

extension RefuelController: InputTextCellDelegate {

    func didGetValue(_ textField: UITextField, tableViewCell: UITableViewCell) {
        guard let option = AddRefuelOption(rawValue: tableViewCell.tag) else { return }

        guard let text = textField.text,
              let value = Double(from: text)
        else {
            // Got wrong value. Set old values back to the text field
            if .litersAmount == option {
                setLiters(to: refuelModel.liters)
            } else if .cost == option {
                setCost(to: refuelModel.cost)
            } else if .odometer == option {
                setOdometer(to: refuelModel.odometer)
            }
            return
        }

        switch option {
        case .litersAmount: refuelModel.liters = value // number.doubleValue
        case .cost: refuelModel.cost = value // number.doubleValue
        case .odometer: refuelModel.odometer = Int(value) // number.intValue
        default: break
        }
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
        refuel.date = refuelModel.date
        refuel.liters = refuelModel.liters
        refuel.cost = refuelModel.cost
        refuel.odometer = Int64(refuelModel.odometer)
        do {
            if context.hasChanges {
                try context.save()
            }
            delegate?.refuelDidSave(refuel)
            if editableRefuel != nil {
                // Dissmiss this view controller if the selected refuel is edited
                navigationController?.popViewController(animated: true)
            } else {
                // Show success message if a new refuel's is created
                PresenterManager.showMessage(
                    withTitle: NSLocalizedString("Success", comment: ""),
                    andMessage: NSLocalizedString("DataSaved", comment: ""),
                    byViewController: self)
            }
        } catch {
            let nserror = error as NSError
            PresenterManager.showMessage(
                withTitle: NSLocalizedString("Error", comment: ""),
                andMessage: "\(NSLocalizedString("DeviceError", comment: "")) \(nserror) \(nserror.userInfo)",
                byViewController: self)
            context.rollback()
        }
    }

}
