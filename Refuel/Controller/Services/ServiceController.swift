//
//  ServiceController.swift
//  Refuel
//
//  Created by Яна Латышева on 29.06.2021.
//

import UIKit

protocol ServiceControllerDelegate {
    func serviceDidSave(_ service: CDService)
}

/** Adding or editing a service
 */
class ServiceController: ParentController /*UITableViewController*/ {

    // MARK: - Properties

    struct ServiceModel {
        var date = Date()
        var odometer = 0
        var cost = 0.0
        var text = ""
    }

    private var serviceModel = ServiceModel()
//    private var date = Date()
//    private var odometer = 0
//    private var cost = 0.0
//    private var serviceText = ""

    var delegate: ServiceControllerDelegate?
    private var caption = "Добавить ТО"

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

            caption = "Изменить данные"
            serviceModel.date = service.date ?? Date()
            serviceModel.odometer = Int(service.odometer)
            serviceModel.cost = service.cost
            serviceModel.text = service.text ?? ""
        }
    }

    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }


    // MARK: - Methods

    private func configureUI() {
        title = caption

        tableView.separatorStyle = .none

        tableView.register(LabelsCell.self, forCellReuseIdentifier: K.Identifier.GeneralCells.labelsCell)
        tableView.register(DatePickerCell.self, forCellReuseIdentifier: K.Identifier.GeneralCells.datePickerCell)
        tableView.register(InputTextCell.self, forCellReuseIdentifier: K.Identifier.GeneralCells.inputTextCell)
        tableView.register(MultiLineTextCell.self, forCellReuseIdentifier: K.Identifier.GeneralCells.multiLineTextCell)
        tableView.register(ButtonCell.self, forCellReuseIdentifier: K.Identifier.GeneralCells.buttonCell)

    }

//    private func getString(from doubleValue: Double) -> String {
//        let number = NSNumber(value: doubleValue)
//        let numberFormatter = NumberFormatter()
//        numberFormatter.allowsFloats = true
//        numberFormatter.numberStyle = .decimal
//        return numberFormatter.string(from: number) ?? "0"
//    }

    private func setCost(to value: Double) {
        let indexPath = IndexPath(row: AddServiceOption.cost.rawValue, section: 0)
        let cell = tableView.cellForRow(at: indexPath) as! InputTextCell
        cell.textField.text = value.toString() //getString(from: value)
    }

    private func setOdometer(to value: Int) {
        let indexPath = IndexPath(row: AddServiceOption.odometer.rawValue, section: 0)
        let cell = tableView.cellForRow(at: indexPath) as! InputTextCell
        cell.textField.text = String(value)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AddServiceOption.allCases.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell: UITableViewCell

        let cellOption = AddServiceOption(rawValue: indexPath.row)!
//        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        switch cellOption {
        case .selectedVehicle:
            let labelsCell = tableView.dequeueReusableCell(withIdentifier: K.Identifier.GeneralCells.labelsCell, for: indexPath) as! LabelsCell
            labelsCell.setTextCaptionLabel(to: cellOption.description)
            if let manufacturer = VehicleManager.shared.selectedVehicle?.manufacturer,
               let model = VehicleManager.shared.selectedVehicle?.model {
                labelsCell.setTextValueLabel(to: manufacturer + " " + model)
            } else {
                // TODO: - Fatal error
                fatalError("Unexpected nil of selected vehicle!")
            }

            cell = labelsCell

        case .dateLabel:
            let labelsCell = tableView.dequeueReusableCell(withIdentifier: K.Identifier.GeneralCells.labelsCell, for: indexPath) as! LabelsCell
            labelsCell.setTextCaptionLabel(to: cellOption.description)
            labelsCell.setTextValueLabel(to: serviceModel.date.toString())
            cell = labelsCell

        case .datePicker:
            let datePickerCell = tableView.dequeueReusableCell(withIdentifier: K.Identifier.GeneralCells.datePickerCell, for: indexPath) as! DatePickerCell
            datePickerCell.delegate = self
            datePickerCell.setDate(to: serviceModel.date)
            cell = datePickerCell

        case .odometer:
            let inputTextCell = tableView.dequeueReusableCell(withIdentifier: K.Identifier.GeneralCells.inputTextCell, for: indexPath) as! InputTextCell
            inputTextCell.delegate = self
            inputTextCell.textField.keyboardType = .numberPad
            inputTextCell.setTextCaptionLabel(to: cellOption.description)
            inputTextCell.textField.text = String(serviceModel.odometer)
            cell = inputTextCell

        case .cost:
            let inputTextCell = tableView.dequeueReusableCell(withIdentifier: K.Identifier.GeneralCells.inputTextCell, for: indexPath) as! InputTextCell
            inputTextCell.delegate = self
            inputTextCell.textField.keyboardType = .decimalPad
            inputTextCell.setTextCaptionLabel(to: cellOption.description)
            inputTextCell.textField.text = serviceModel.cost.toString()
            cell = inputTextCell

        case .text:
            let multiLineTextCell = tableView.dequeueReusableCell(withIdentifier: K.Identifier.GeneralCells.multiLineTextCell, for: indexPath) as! MultiLineTextCell
            multiLineTextCell.delegate = self
//            inputTextCell.textField.keyboardType = .default
            multiLineTextCell.setTextCaptionLabel(to: cellOption.description)
            multiLineTextCell.setText(to: serviceModel.text)
            cell = multiLineTextCell

        case .save:
            cell = tableView.dequeueReusableCell(withIdentifier: K.Identifier.GeneralCells.buttonCell, for: indexPath)
            (cell as! ButtonCell).delegate = self

        }

        cell.tag = indexPath.row
        return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let cellOption = AddServiceOption(rawValue: indexPath.row), cellOption == .datePicker {
            return datePickerCurrentHeight
        } else {
//            return K.defaultRowHeight
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


// MARK: - DatePickerCellDelegate

extension ServiceController: DatePickerCellDelegate {

    func dateChanged(to date: Date) {
        // We got the date value from cell with date picker
        // And now let's assing it to date label
        if let cell = tableView.cellForRow(at: IndexPath(row: AddServiceOption.dateLabel.rawValue, section: 0)) as? LabelsCell {
            cell.setTextValueLabel(to: date.toString())
        }

//        self.date = date
        serviceModel.date = date
    }
}


// MARK: - InputTextCellDelegate

extension ServiceController: InputTextCellDelegate {

    func didGetValue(_ textField: UITextField, tableViewCell: UITableViewCell) {
        guard let option = AddServiceOption(rawValue: tableViewCell.tag) else { return }

        guard let text = textField.text,
              let value = Double(from: text) else {
//              let number = NumberFormatter().number(from: text) else {

            // Got wrong value. Set old values back to the text field
            if .odometer == option { setOdometer(to: serviceModel.odometer) }
            else if .cost == option { setCost(to: serviceModel.cost) }
            return
        }

        switch option {
        case .odometer: serviceModel.odometer = Int(value) // number.intValue
        case .cost: serviceModel.cost = value // number.doubleValue
        default:
            fatalError("Wrong TAG!")
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

            // TODO: - Implement delegate
            delegate?.serviceDidSave(service)

            if let _ = editableService {
                // Dissmiss this view controller if the selected refuel is edited
                navigationController?.popViewController(animated: true)

            } else {
                dismiss(animated: true, completion: nil)
                // Show success message if a new service is created
                //PresenterManager.shared.showMessage(withTitle: "Успешно", andMessage: "Данные сохранены", byViewController: self)

                // TODO: - Implement dismiss
                //dismiss(animated: true, completion: nil)
            }
        } catch {

            // TODO: catch errors, show alarm
            let nserror = error as NSError
            fatalError("DEBUG: Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}
