//
//  ViewController.swift
//  Refuel
//
//  Created by Яна Латышева on 05.12.2020.
//

import UIKit

class AddRefuelController: UITableViewController {

    // MARK: - Properties
    
    private var date: Date?
    private var liters: Double?
    private var sum: Double?
    private var odo: Int?
    
    
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
        tableView.isScrollEnabled = false
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
        return 60
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
    var dateDelegate: Date? {
        get {
            return date
        }
        set {
            print("DEBUG: set new date")
            date = newValue
        }
    }
    
    var litersDelegate: Double? {
        get {
            return liters
        }
        set {
            print("DEBUG: set new liters")
            liters = newValue
        }
    }
    
    var sumDelegate: Double? {
        get {
            return sum
        }
        set {
            print("DEBUG: set new sum")
            sum = newValue
        }
    }
    
    var odoDelegate: Int? {
        get {
            return odo
        }
        set {
            print("DEBUG: set new odo")
            odo = newValue
        }
    }
    
    func saveButtonTapped() {
        print("DEBUG: save button tapped")
        
        guard let date = date else {
            print("DEBUG: show message -> set date ?? or should just use today")
            return
        }
        
        guard let liters = liters else {
            print("DEBUG: show message -> incorrect liters")
            return
        }
        
        guard let sum = sum else {
            print("DEBUG: show message -> incorrect sum")
            return
        }
        
        guard let odo = odo else {
            print("DEBUG: show message -> incorrect odo")
            return
        }
        
        let refuel = Refuel(date: date, liters: liters, sum: sum, odo: odo)
        
        print("DEBUG: save data \(refuel)")
    }
}
