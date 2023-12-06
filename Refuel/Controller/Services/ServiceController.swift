//
//  ServiceController.swift
//  Refuel
//
//  Created by Яна Латышева on 29.06.2021.
//

import UIKit

protocol ServiceControllerDelegate: AnyObject {
    func serviceDidSave(_ service: CDService)
}

/** Adding or editing a service
 */
class ServiceController: ParentController {

    // MARK: - Properties

    struct ServiceModel {
        var date = Date()
        var odometer = 0
        var cost = 0.0
        var text = ""
    }

    weak var delegate: ServiceControllerDelegate?
    private var serviceModel = ServiceModel()
    private var caption = NSLocalizedString("AddingService", comment: "")
    private var datePickerCurrentHeight: CGFloat = 0.0
    private var rowDatePickerHeight: CGFloat {
        // row heigth equals width of main view
        return view.frame.width
    }

    /** The `editableService` refer to the editing service's record.
     If a new service's record is created then the `editableService` will be nil.
    */
    var editableService: CDService? {
        didSet {
            guard let service = editableService else { return }

            caption = NSLocalizedString("EditData", comment: "")
            serviceModel.date = service.date ?? Date()
            serviceModel.odometer = Int(service.odometer)
            serviceModel.cost = service.cost
            serviceModel.text = service.text ?? ""
        }
    }
    // swiftlint:disable force_cast
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    // swiftlint:enable force_cast
    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    // MARK: - Methods

    private func configureUI() {
        title = caption

        tableView.separatorStyle = .none

        tableView.register(LabelsCell.self, forCellReuseIdentifier: CellIdentifiers.GeneralCells.labelsCell)
        tableView.register(DatePickerCell.self, forCellReuseIdentifier: CellIdentifiers.GeneralCells.datePickerCell)
        tableView.register(InputTextCell.self, forCellReuseIdentifier: CellIdentifiers.GeneralCells.inputTextCell)
        tableView.register(MultiLineTextCell.self,
                           forCellReuseIdentifier: CellIdentifiers.GeneralCells.multiLineTextCell)
        tableView.register(ButtonCell.self, forCellReuseIdentifier: CellIdentifiers.GeneralCells.buttonCell)

    }

    private func setCost(to value: Double) {
        let indexPath = IndexPath(row: AddServiceOption.cost.rawValue, section: 0)
        if let cell = tableView.cellForRow(at: indexPath) as? InputTextCell {
            cell.textField.text = value.toString()
        }
    }

    private func setOdometer(to value: Int) {
        let indexPath = IndexPath(row: AddServiceOption.odometer.rawValue, section: 0)
        if let cell = tableView.cellForRow(at: indexPath) as? InputTextCell {
            cell.textField.text = String(value)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AddServiceOption.allCases.count
    }

    // TODO: This method should be refactored
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        let cellOption = AddServiceOption(rawValue: indexPath.row)!
        switch cellOption {
        case .selectedVehicle:
            guard let labelsCell = tableView.dequeueReusableCell(
                withIdentifier: CellIdentifiers.GeneralCells.labelsCell,
                for: indexPath) as? LabelsCell else {
                return UITableViewCell()
            }
            labelsCell.setTextCaptionLabel(to: cellOption.description)
            if let manufacturer = VehicleManager.shared.selectedVehicle?.manufacturer,
               let model = VehicleManager.shared.selectedVehicle?.model {
                labelsCell.setTextValueLabel(to: manufacturer + " " + model)
            }
            cell = labelsCell
        case .dateLabel:
            guard let labelsCell = tableView.dequeueReusableCell(
                withIdentifier: CellIdentifiers.GeneralCells.labelsCell,
                for: indexPath) as? LabelsCell else {
                return UITableViewCell()
            }
            labelsCell.setTextCaptionLabel(to: cellOption.description)
            labelsCell.setTextValueLabel(to: serviceModel.date.toString())
            cell = labelsCell
        case .datePicker:
            guard let datePickerCell = tableView.dequeueReusableCell(
                withIdentifier: CellIdentifiers.GeneralCells.datePickerCell,
                for: indexPath) as? DatePickerCell else {
                    return UITableViewCell()
                }
            datePickerCell.delegate = self
            datePickerCell.setDate(to: serviceModel.date)
            cell = datePickerCell
        case .odometer:
            guard let inputTextCell = tableView.dequeueReusableCell(
                withIdentifier: CellIdentifiers.GeneralCells.inputTextCell,
                for: indexPath) as? InputTextCell else {
                return UITableViewCell()
            }
            inputTextCell.delegate = self
            inputTextCell.textField.keyboardType = .numberPad
            inputTextCell.setTextCaptionLabel(to: cellOption.description)
            inputTextCell.textField.text = String(serviceModel.odometer)
            cell = inputTextCell
        case .cost:
            guard let inputTextCell = tableView.dequeueReusableCell(
                withIdentifier: CellIdentifiers.GeneralCells.inputTextCell,
                for: indexPath) as? InputTextCell else {
                return UITableViewCell()
            }
            inputTextCell.delegate = self
            inputTextCell.textField.keyboardType = .decimalPad
            inputTextCell.setTextCaptionLabel(to: cellOption.description)
            inputTextCell.textField.text = serviceModel.cost.toString()
            cell = inputTextCell
        case .text:
            guard let multiLineTextCell = tableView.dequeueReusableCell(
                withIdentifier: CellIdentifiers.GeneralCells.multiLineTextCell,
                for: indexPath) as? MultiLineTextCell else {
                return UITableViewCell()
            }
            multiLineTextCell.delegate = self
            multiLineTextCell.setTextCaptionLabel(to: cellOption.description)
            multiLineTextCell.setText(to: serviceModel.text)
            cell = multiLineTextCell
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
        if let cellOption = AddServiceOption(rawValue: indexPath.row), cellOption == .datePicker {
            return datePickerCurrentHeight
        } else {
            return tableView.estimatedRowHeight
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cellOption = AddServiceOption(rawValue: indexPath.row), cellOption == .dateLabel {
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

extension ServiceController: DatePickerCellDelegate {

    func dateChanged(to date: Date) {
        // We got the date value from cell with date picker
        // And now let's assing it to date label
        if let cell = tableView.cellForRow(at: IndexPath(row: AddServiceOption.dateLabel.rawValue,
                                                         section: 0)) as? LabelsCell {
            cell.setTextValueLabel(to: date.toString())
        }
        serviceModel.date = date
    }
}

// MARK: - InputTextCellDelegate

extension ServiceController: InputTextCellDelegate {

    func didGetValue(_ textField: UITextField, tableViewCell: UITableViewCell) {
        guard let option = AddServiceOption(rawValue: tableViewCell.tag) else { return }
        guard let text = textField.text,
              let value = Double(from: text) else {
            // Got wrong value. Set old values back to the text field
            if .odometer == option {
                setOdometer(to: serviceModel.odometer)
            } else if .cost == option {
                setCost(to: serviceModel.cost)
            }
            return
        }
        switch option {
        case .odometer: serviceModel.odometer = Int(value)
        case .cost: serviceModel.cost = value
        default: break
        }
    }
}

// MARK: - MultiLineTextCellDelegate
extension ServiceController: MultiLineTextCellDelegate {

    func didGetText(_ text: String) {
        serviceModel.text = text
    }
}

// MARK: - ButtonCellDelegate

extension ServiceController: ButtonCellDelegate {

    func saveButtonTapped() {
        let service: CDService
        if let editableService = editableService {
            service = editableService
        } else {
            service = CDService(context: context)
            service.vehicle = VehicleManager.shared.selectedVehicle
        }
        service.date = serviceModel.date
        service.odometer = Int64(serviceModel.odometer)
        service.cost = serviceModel.cost
        service.text = serviceModel.text
        do {
            if context.hasChanges {
                try context.save()
            }
            delegate?.serviceDidSave(service)
            if editableService != nil {
                // Dissmiss this view controller if the selected refuel is edited
                navigationController?.popViewController(animated: true)
            } else {
                dismiss(animated: true, completion: nil)
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
