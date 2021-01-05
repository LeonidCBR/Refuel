//
//  LoadingController.swift
//  Refuel
//
//  Created by Яна Латышева on 14.12.2020.
//

import UIKit
//import CoreData

class LoadingController: UIViewController {

    // MARK: - Properties
    let activityIndicator = UIActivityIndicatorView()
    
    let loadingLabel: UILabel = {
        let label = UILabel()
        label.text = "Загрузка..."
        label.font = UIFont(name: "HelveticaNeue-Bold", size: 24)
        label.textColor = .white
        return label
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        PersistentManager.shared.fetchVehicles { vehicles in
            if vehicles.isEmpty {
                PresenterManager.shared.show(.createVehicleController)
            } else {
                PresenterManager.shared.show(.mainTabBarController)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        activityIndicator.startAnimating()
    }
    
    
    // MARK: - Methods
    
    private func configureUI() {
        view.backgroundColor = .systemBlue
        
        view.addSubview(loadingLabel)
        loadingLabel.anchor(centerX: view.centerXAnchor,
                            centerY: view.centerYAnchor)
        
        view.addSubview(activityIndicator)
        activityIndicator.anchor(top: loadingLabel.bottomAnchor, paddingTop: 10,
                                 centerX: view.centerXAnchor)
        
    }
    
}
