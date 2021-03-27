//
//  CreateVehicleController.swift
//  Refuel
//
//  Created by Яна Латышева on 14.12.2020.
//

import UIKit
import CoreData

protocol VehicleControllerDelegate {
    func didSave()
}


class VehicleController: UITableViewController {
    
    // MARK: - Properties
    private var caption = "Добавление транспортного средства"
    private var manufacturer = ""
    private var model = ""
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var delegate: VehicleControllerDelegate?
    
    // It will be not nil if it is being edited
    var editableVehicle: CDVehicle? {
        didSet {
            guard let vehicle = editableVehicle else { return }
//            captionLabel.text = "Редактирование транспортного средства"
//            manufacturerTextField.text = editableVehicle?.manufacturer
//            modelTextField.text = editableVehicle?.model
            caption = "Редактирование транспортного средства"
            manufacturer = vehicle.manufacturer ?? ""
            model = vehicle.model ?? ""
        }
    }
    

/*
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
 */
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    
    // MARK: - Methods
    
    private func configureUI() {
        
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        
        tableView.register(CVCaptionCell.self, forCellReuseIdentifier: K.Identifier.CreateVehicle.captionCell)
        tableView.register(CVInputTextCell.self, forCellReuseIdentifier: K.Identifier.CreateVehicle.inputTextCell)
        tableView.register(ButtonCell.self, forCellReuseIdentifier: K.Identifier.CreateVehicle.buttonCell)
        /*
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
        */
        
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
    
//    @objc private func handleSaveButtonTapped() {
//    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CreateVehicleOption.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        
        let cellOption = CreateVehicleOption(rawValue: indexPath.row)!
        switch cellOption {
        case .caption:
            let captionCell = tableView.dequeueReusableCell(withIdentifier: K.Identifier.CreateVehicle.captionCell, for: indexPath) as! CVCaptionCell
            captionCell.setCaption(caption)
            cell = captionCell
            
        case .manufacturer:
            let manufacturerCell = tableView.dequeueReusableCell(withIdentifier: K.Identifier.CreateVehicle.inputTextCell, for: indexPath) as! CVInputTextCell
            manufacturerCell.cellOption = .manufacturer
            manufacturerCell.delegate = self
            manufacturerCell.setPlaceholder("Марка")
            manufacturerCell.setText(manufacturer)
            cell = manufacturerCell
            
        case .model:
            let modelCell = tableView.dequeueReusableCell(withIdentifier: K.Identifier.CreateVehicle.inputTextCell, for: indexPath) as! CVInputTextCell
            modelCell.cellOption = .model
            modelCell.delegate = self
            modelCell.setPlaceholder("Модель")
            modelCell.setText(model)
            cell = modelCell
            
        case .save:
            let buttonCell = tableView.dequeueReusableCell(withIdentifier: K.Identifier.CreateVehicle.buttonCell, for: indexPath) as! ButtonCell
            buttonCell.delegate = self
            cell = buttonCell
        }
        
        return cell
    }
}


// MARK: - ButtonCellDelegate

extension VehicleController: ButtonCellDelegate {
    func saveButtonTapped() {
        
    //        guard let manufacturer = manufacturerTextField.text, let model = modelTextField.text else { return }
            
            // TODO: Show alerts
            
            if manufacturer.isEmpty {
                PresenterManager.shared.showMessage(withTitle: "Ошибка!", andMessage: "Введите наименование марки.", byViewController: self)
                return
            }
            
            if model.isEmpty {
                PresenterManager.shared.showMessage(withTitle: "Ошибка!", andMessage: "Введите наименование модели.", byViewController: self)
                return
            }
            
            //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
            let newVehicle: CDVehicle
            
            do {
                
                if let didEditVehicle = editableVehicle {
                    
                    // Editing vehicle
                    didEditVehicle.manufacturer = manufacturer
                    didEditVehicle.model = model
                    newVehicle = didEditVehicle
                    
                } else {
                    
                    // Creating new vehicle
                    let vehicle = CDVehicle(context: context)
                    vehicle.manufacturer = manufacturer
                    vehicle.model = model
                    newVehicle = vehicle
                }
                
                if context.hasChanges {
                    try context.save()
                }
                
                
                // TODO: - Make a refactor
                // Consider to split save process into adding and editing
                // It will prevent reloading whole table
                
                delegate?.didSave()
                
                // TODO: there is no tab bar
    //            if let tabBarController = tabBarController as? MainTabBarController {
    //                tabBarController.selectedVehicle = newVehicle
    //            }
                
                if let navigationController = navigationController {
                    if let tabBarController = tabBarController as? MainTabBarController {
                        tabBarController.selectedVehicle = newVehicle
                    }
                    navigationController.popViewController(animated: true)
                } else {
                    PresenterManager.shared.showViewController(.mainTabBarController(selectedVehicle: newVehicle))
                }
                
            } catch {
                
                // TODO: catch errors, show alarm
                
                let nserror = error as NSError
                fatalError("DEBUG: Unresolved error \(nserror), \(nserror.userInfo)")
            }
    }
}


// MARK: - CVInputTextCellDelegate
extension VehicleController: CVInputTextCellDelegate {
    func didChangeText(_ inputTextCell: CVInputTextCell, withText text: String) {
        switch inputTextCell.cellOption {
        case .manufacturer:
            manufacturer = text
        case .model:
            model = text
        case .none:
            fatalError("It has to have a value!")
        }
    }
}
