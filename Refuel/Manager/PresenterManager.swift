//
//  PresenterManager.swift
//  Refuel
//
//  Created by Яна Латышева on 14.12.2020.
//

import UIKit

struct PresenterManager {
    
    static let shared = PresenterManager()
    
    private init() {}
    
    enum VC {
        case mainTabBarController(selectedVehicle: CDVehicle)
        case createVehicleController
    }
    
    func show(_ viewControllerToShow: VC) {
        var viewController: UIViewController
        var window: UIWindow?
        
        switch viewControllerToShow {
        case .mainTabBarController(let vehicle):
            viewController = MainTabBarController()
            (viewController as! MainTabBarController).selectedVehicle = vehicle
        case .createVehicleController:
            viewController = CreateVehicleController()
        }
        
        
        if #available(iOS 13, *) {
            // Use SceneDelegate
            if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
               let win = sceneDelegate.window {
                window = win
            }
            
        } else {
            
            // Use AppDelegate
            if let applicationDelegate = UIApplication.shared.delegate,
               let win = applicationDelegate.window {
                window = win
            }
        }
        
        if let window = window {
            UIView.transition(with: window, duration: 0.25, options: .transitionCrossDissolve, animations: nil, completion: nil)
            window.rootViewController = viewController
        }
    }
    
}
