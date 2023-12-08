//
//  ParentNavigationController.swift
//  Refuel
//
//  Created by Яна Латышева on 21.03.2021.
//

import UIKit

class ParentController: UITableViewController {

    // MARK: - Properties

    var shouldObserveVehicle = true
    var shouldTapRecognizer = false

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - Methods

    private func configure() {
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        }
        if shouldObserveVehicle {
            let modelVehicle = VehicleManager.shared.selectedVehicle?.model ?? "Unknown"
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: modelVehicle,
                                                                style: .plain,
                                                                target: self,
                                                                action: #selector(handleSelectVehicleButtonTapped))
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(vehicleDidSelect),
                                                   name: NotificationNames.RFVehicleDidSelect,
                                                   object: nil)
        }
        if shouldTapRecognizer {
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
    }

    private func setBarButtonItem() {
        navigationItem.rightBarButtonItem?.title = VehicleManager.shared.selectedVehicle?.model
    }

    // MARK: - Selectors

    @objc private func handleSelectVehicleButtonTapped() {
        let choiceController = VehiclesController()
        choiceController.isSelectingMode = true
        choiceController.shouldObserveVehicle = false
        choiceController.caption = NSLocalizedString("ChooseVehicle", comment: "")
        present(UINavigationController(rootViewController: choiceController), animated: true, completion: nil)
    }

    @objc func vehicleDidSelect() {
        setBarButtonItem()
    }

}
