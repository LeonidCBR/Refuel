//
//  ViewController.swift
//  Refuel
//
//  Created by Яна Латышева on 05.12.2020.
//

import UIKit

class AddRefuelController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Methods
    
    private func configureUI() {
        title = "Add refuel"
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
        view.backgroundColor = .white
        tableView.isScrollEnabled = false
        
        // TODO: - !!! remember to change
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: K.Identifier.addRefuel)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.Identifier.addRefuel, for: indexPath)

        cell.textLabel?.text = "Choose the vehicle"

        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        // remove extra lines from the bottom
        return UIView()
    }

   



 


}

