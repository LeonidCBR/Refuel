//
//  LoadingController.swift
//  Refuel
//
//  Created by Яна Латышева on 14.12.2020.
//

import UIKit
import CoreData

class LoadingController: UIViewController {

    // MARK: - Properties
    
    let activityIndicator = UIActivityIndicatorView()
    
    let loadingLabel: UILabel = {
        let label = UILabel()
        label.text = "Загрузка..."
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()


    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        perfomLoading()
    }
    
    
    // MARK: - Methods
    
    private func configureUI() {
        view.backgroundColor = .systemBlue
        
        view.addSubview(loadingLabel)
        loadingLabel.anchor(leading: view.safeAreaLayoutGuide.leadingAnchor,
                            paddingLeading: 20.0,
                            trailing: view.safeAreaLayoutGuide.trailingAnchor,
                            paddingTrailing: 20.0, centerY: view.centerYAnchor)
        
        view.addSubview(activityIndicator)
        activityIndicator.anchor(top: loadingLabel.bottomAnchor, paddingTop: 10,
                                 centerX: view.centerXAnchor)

    }

    private func perfomLoading() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        // Check for persistent errors
        if let persistentError = appDelegate.persistentError {
            loadingLabel.text = persistentError.localizedDescription
            PresenterManager.showMessage(withTitle: "Ошибка!", andMessage: "Возникла непредвиденная ошибка при работе с памятью устройства.", byViewController: self)
            return
        }

        activityIndicator.startAnimating()

        let context = appDelegate.persistentContainer.viewContext
        let request: NSFetchRequest<CDVehicle> = CDVehicle.fetchRequest()
        request.fetchLimit = 1
        if let countOfVehicles = try? context.count(for: request),
           countOfVehicles > 0,
           let vehicles = try? context.fetch(request),
           let vehicle = vehicles.first {
            VehicleManager.shared.selectedVehicle = vehicle
            PresenterManager.showViewController(.mainTabBarController)
        } else {
            PresenterManager.showViewController(.createVehicleController)
        }
    }
    
}
