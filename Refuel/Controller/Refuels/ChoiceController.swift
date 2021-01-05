//
//  ChoiceController.swift
//  Refuel
//
//  Created by Яна Латышева on 14.12.2020.
//

import UIKit

protocol ChoiceControllerDelegate {
    // TODO: - remember add dates from and to
    func didChoose(_ vehicle: Vehicle)
}

class ChoiceController: UIViewController {

    // MARK: - Properties
    var delegate: ChoiceControllerDelegate?
    
    lazy var choiceButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Choose", for: .normal)
        btn.addTarget(self, action: #selector(choiceButtonTapped), for: .touchUpInside)
        return btn
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    
    // MARK: - Methods
    
    private func configureUI() {
        view.backgroundColor = .white
        view.addSubview(choiceButton)
        choiceButton.anchor(centerX: view.centerXAnchor,
                            centerY: view.centerYAnchor)
    }
    
    
    // MARK: - Selectors
    @objc private func choiceButtonTapped() {
        
        // create template vehicle
        let testVehicle = Vehicle(manufacturer: "Toyota", model: "Supra")
        
        delegate?.didChoose(testVehicle)
        dismiss(animated: true, completion: nil)
    }
}
