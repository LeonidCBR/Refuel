//
//  CreateVehicleController.swift
//  Refuel
//
//  Created by Яна Латышева on 14.12.2020.
//

import UIKit

class CreateVehicleController: UIViewController {
    
    // MARK: - Properties
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.text = "Добавление транспортного средства"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()

    private let manufacturerTextField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .roundedRect
        tf.placeholder = "Марка"
        return tf
    }()
    private let modelTextField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .roundedRect
        tf.placeholder = "Модель"
        return tf
    }()
    
    private lazy var saveButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Сохранить", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = .systemBlue
        btn.layer.cornerRadius = 10
        btn.addTarget(self, action: #selector(handleSaveButtonTapped), for: .touchUpInside)
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
        
        manufacturerTextField.anchor(width: 200, height: 40)
        modelTextField.anchor(width: 200, height: 40)
        saveButton.anchor(width: 200, height: 40)
        
        let mainStackView = UIStackView(arrangedSubviews: [captionLabel, manufacturerTextField, modelTextField, saveButton])
        mainStackView.axis = .vertical
        mainStackView.distribution = .equalSpacing
        mainStackView.alignment = .center
        mainStackView.spacing = 25
        
        view.addSubview(mainStackView)
        mainStackView.anchor(centerX: view.centerXAnchor,
                             centerY: view.centerYAnchor)
//        if #available(iOS 11.0, *) {
//            mainStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 20,
//                                 bottom: view.safeAreaLayoutGuide.bottomAnchor, paddingBottom: 20,
//                                 leading: view.safeAreaLayoutGuide.leadingAnchor, paddingLeading: 20,
//                                 trailing: view.trailingAnchor, paddingTrailing: 20)
//        } else {
//            // Fallback on earlier versions
//            mainStackView.anchor(top: topLayoutGuide.topAnchor, paddingTop: 20,
//                                 bottom: bottomLayoutGuide.bottomAnchor, paddingBottom: 20,
//                                 leading: view.leadingAnchor, paddingLeading: 20,
//                                 trailing: view.trailingAnchor, paddingTrailing: 20)
//        }
        
        
        
//        view.addSubview(saveButton)
//        saveButton.anchor(width: 200,
//                          height: 40,
//                          centerX: view.centerXAnchor, centerY: view.centerYAnchor)
    }
    
    
    // MARK: - Selectors
    @objc private func handleSaveButtonTapped() {
        guard let manufacturer = manufacturerTextField.text, let model = modelTextField.text else { return }
        
        // TODO: Show alerts
        
        if manufacturer.isEmpty {
            print("DEBUG: manufacturer is empty.")
            return
        }
        
        if model.isEmpty {
            print("DEBUG: model is empty.")
            return
        }
        
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        let vehicle = Vehicle(manufacturer: manufacturer, model: model)
        PersistentManager.shared.saveVehicle(vehicle)
    }
}
