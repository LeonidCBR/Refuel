//
//  ViewController.swift
//  Refuel
//
//  Created by Яна Латышева on 05.12.2020.
//

import UIKit

class AddRefuelController: UITableViewController {

    // MARK: - Properties
    
    private var dateValue: Date?
    private var litersValue: Double?
    private var costValue: Double?
    private var odometerValue: Int?
    
    private var rowDatePickerHeight: CGFloat {
        // row heigth equals width of main view
        return view.frame.width
    }
    
    private var datePickerCurrentHeight: CGFloat = 0
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    // MARK: - Methods
    
    private func configureUI() {
        title = "Add refuel"
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
        view.backgroundColor = .white
        
//        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        tableView.register(AddRefuelCell.self, forCellReuseIdentifier: K.Identifier.addRefuel)
        
        // Hide keyboard when tap out of TextFields
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        /*
         There could be issues if you are dealing with tableviews and adding this tap gesture,
         selecting the rows, didSelectRowAtIndex path could not be fired until pressed long.
         Solution:
                tap.cancelsTouchesInView = false
         */
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    
    // MARK: - Selectors

    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return CellOption.allCases.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.Identifier.addRefuel, for: indexPath) as! AddRefuelCell
        cell.delegate = self
        cell.cellOption = CellOption(rawValue: indexPath.row)
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let cellOption = CellOption(rawValue: indexPath.row), cellOption == .datePicker {
            return datePickerCurrentHeight
        } else {
            return 60
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cellOption = CellOption(rawValue: indexPath.row), cellOption == .dateLabel {
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


// MARK: - AddRefuelCellDelegate

extension AddRefuelController: AddRefuelCellDelegate {
    
    var date: Date? {
        get {
            return dateValue
        }
        set {
            dateValue = newValue
        }
    }
    
    var liters: Double? {
        get {
            return litersValue
        }
        set {
            litersValue = newValue
        }
    }
    
    var cost: Double? {
        get {
            return costValue
        }
        set {
            costValue = newValue
        }
    }
    
    var odometer: Int? {
        get {
            return odometerValue
        }
        set {
            odometerValue = newValue
        }
    }
    
    func dateChanged(newDate date: Date) {
        if let cell = tableView.cellForRow(at: IndexPath(row: CellOption.dateLabel.rawValue, section: 0)) as? AddRefuelCell {
            cell.setDate(to: date)
        }
    }
    
    func saveButtonTapped() {
        print("DEBUG: save button tapped")
        
        guard let date = dateValue else {
            print("DEBUG: show message -> set date ?? or should just use today")
            return
        }
        
        guard let liters = litersValue else {
            print("DEBUG: show message -> incorrect liters")
            return
        }
        
        guard let sum = costValue else {
            print("DEBUG: show message -> incorrect sum")
            return
        }
        
        guard let odo = odometerValue else {
            print("DEBUG: show message -> incorrect odo")
            return
        }
        
        let refuel = Refuel(date: date, liters: liters, sum: sum, odo: odo)
        
        print("DEBUG: save data \(refuel)")
    }
}
