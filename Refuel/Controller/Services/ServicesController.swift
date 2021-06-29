//
//  ServicesController.swift
//  Refuel
//
//  Created by Яна Латышева on 21.03.2021.
//

import UIKit
import CoreData

class ServicesController: ParentController {

    // MARK: - Properties

    var services: [CDService]?
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchServices()
    }

    
    // MARK: - Methods
    
    private func configureUI() {
        title = "Обслуживание"

        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
        view.backgroundColor = .white

        let plusBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addService))
        navigationItem.rightBarButtonItems?.append(plusBarButtonItem)

        tableView.register(ServiceCell.self, forCellReuseIdentifier: K.Identifier.Services.serviceCell)
    }

    private func fetchServices() {
        if let services = VehicleManager.shared.selectedVehicle?.services?.allObjects as? [CDService] {
            self.services = services.sorted() {$0.odometer < $1.odometer}
        }

        tableView.reloadData()
    }


    // MARK: - Selectors

    @objc private func addService() {
        let addService = ServiceController()
        navigationController?.pushViewController(addService, animated: true)
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return services?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedService = ServiceController()
        navigationController?.pushViewController(selectedService, animated: true)
    }
}
