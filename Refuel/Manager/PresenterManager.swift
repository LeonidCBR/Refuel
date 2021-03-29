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
        case mainTabBarController
        case createVehicleController
    }
    
    func showViewController(_ viewControllerToShow: VC) {
        var viewController: UIViewController
        var window: UIWindow?
        
        switch viewControllerToShow {
        
        case .mainTabBarController:
            viewController = MainTabBarController()
            
        case .createVehicleController:
            viewController = VehicleController()
            (viewController as! VehicleController).shouldTapRecognizer = true
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
    
    func showMessage(withTitle title: String, andMessage message: String, byViewController viewController: UIViewController, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        viewController.present(alert, animated: true, completion: completion)
    }
    
}
