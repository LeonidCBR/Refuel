//
//  ChoiceController.swift
//  Refuel
//
//  Created by Яна Латышева on 14.12.2020.
//

import UIKit
import CoreData

protocol ChoiceControllerDelegate {
    // TODO: - remember add dates from and to
    func didChoose(_ vehicle: CDVehicle)
}

class ChoiceController: UIViewController {

    // MARK: - Properties
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var vehicles: [CDVehicle]?
    var selectedVehicle: CDVehicle?
    
    var delegate: ChoiceControllerDelegate?
    
    lazy var choiceButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Choose", for: .normal)
        btn.addTarget(self, action: #selector(choiceButtonTapped), for: .touchUpInside)
        return btn
    }()
    
    lazy var vehiclePicker: UIPickerView = {
        let pv = UIPickerView()
        pv.delegate = self
        pv.dataSource = self
        return pv
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchVehicles()
    }
    
    
    // MARK: - Methods
    
    private func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(vehiclePicker)
        vehiclePicker.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 20,
                             leading: view.safeAreaLayoutGuide.leadingAnchor, paddingLeading: 20,
                             trailing: view.safeAreaLayoutGuide.trailingAnchor, paddingTrailing: 20,
                             height: 150)
        
        view.addSubview(choiceButton)
        choiceButton.anchor(centerX: view.centerXAnchor,
                            centerY: view.centerYAnchor)
    }
    
    private func fetchVehicles() {
        let request: NSFetchRequest<CDVehicle> = CDVehicle.fetchRequest()
        
        // TODO: Catch errors
        
        vehicles = try! context.fetch(request)
        vehiclePicker.reloadComponent(0)
        
        if let vehicles = vehicles, vehicles.count > 0 {
            selectedVehicle = vehicles[0]
            vehiclePicker.selectRow(0, inComponent: 0, animated: false)
        }
    }
    
    
    // MARK: - Selectors
    @objc private func choiceButtonTapped() {
        
        // TODO: - Pass vehicle and dismiss
        if let selectedVehicle = selectedVehicle {
            delegate?.didChoose(selectedVehicle)
            dismiss(animated: true, completion: nil)
        } else {
//            if let vehicles = vehicles, vehicles.count > vehiclePicker.selectedRow(inComponent: 0) {
//                let row = vehiclePicker.selectedRow(inComponent: 0)
//                delegate?.didChoose(vehicles[row])
//                dismiss(animated: true, completion: nil)
//            } else {
                print("DEBUG: Selected vehicle is nil!")
//            }
        }
    }
}


// MARK: - UIPickerViewDelegate, UIPickerViewDataSource
extension ChoiceController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return vehicles?.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let vehicle = vehicles?[row], let manufacturer = vehicle.manufacturer, let model = vehicle.model else {
            print("DEBUG: Check the row #\(row)!")
            return nil
        }
        
        return manufacturer + " " + model
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedVehicle = vehicles?[row]
    }

}
