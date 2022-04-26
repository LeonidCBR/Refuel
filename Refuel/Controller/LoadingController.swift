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
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let activityIndicator = UIActivityIndicatorView()
    
    let loadingLabel: UILabel = {
        let label = UILabel()
        label.text = "Загрузка..."
//        label.font = UIFont(name: "HelveticaNeue-Bold", size: 24)
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .white
        return label
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        activityIndicator.startAnimating()
        
        // TODO: Show message with error! Make a refactor!

        let request: NSFetchRequest<CDVehicle> = CDVehicle.fetchRequest()
        request.fetchLimit = 1
        if let countOfVehicles = try? context.count(for: request), countOfVehicles > 0 {
            let vehicles = try! context.fetch(request)
            VehicleManager.shared.selectedVehicle = vehicles.first!
            PresenterManager.shared.showViewController(.mainTabBarController)
        } else {
            PresenterManager.shared.showViewController(.createVehicleController)
        }
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
