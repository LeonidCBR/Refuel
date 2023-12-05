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

    // TODO: - Consider to move 'context' to the Parent class
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var services: [CDService]?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchServices()
    }

    // MARK: - Methods

    private func configureUI() {
        title = NSLocalizedString("Services", comment: "")
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
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

    override func vehicleDidSelect() {
        super.vehicleDidSelect()
        fetchServices()
    }

    // MARK: - Selectors

    @objc private func addService() {
        let addService = ServiceController()
        addService.shouldObserveVehicle = false
        addService.shouldTapRecognizer = true
        addService.delegate = self
        present(addService, animated: true)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return services?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: K.Identifier.Services.serviceCell,
            for: indexPath) as! ServiceCell
        cell.service = services?[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedService = ServiceController()
        selectedService.shouldObserveVehicle = false
        selectedService.shouldTapRecognizer = true
        selectedService.delegate = self
        selectedService.editableService = services?[indexPath.row]
        navigationController?.pushViewController(selectedService, animated: true)
    }

    // Delete service record
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let service = services?[indexPath.row] else { return }
            context.delete(service)
            do {
                if context.hasChanges {
                    try context.save()
                }
                services?.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            } catch {
                let nserror = error as NSError
                PresenterManager.showMessage(
                    withTitle: NSLocalizedString("Error", comment: ""),
                    andMessage: "\(nserror). \(nserror.userInfo)",
                    byViewController: self)
            }
        }
    }
}

// MARK: - ServiceControllerDelegate

extension ServicesController: ServiceControllerDelegate {

    func serviceDidSave(_ service: CDService) {
        guard service.vehicle == VehicleManager.shared.selectedVehicle else { return }
        fetchServices()
    }
}
