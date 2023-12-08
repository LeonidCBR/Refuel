//
//  AppDelegate.swift
//  Refuel
//
//  Created by Яна Латышева on 05.12.2020.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    // Declare for iOS below 13.0
    var window: UIWindow?

    var persistentError: Error?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if #unavailable(iOS 13) {
            // Init window only if iOS version below 13.0
            window = UIWindow(frame: UIScreen.main.bounds)
            window?.rootViewController = LoadingController() // MainTabBarController()
            window?.makeKeyAndVisible()
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication,
                     configurationForConnecting connectingSceneSession: UISceneSession,
                     options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Refuel")
        container.loadPersistentStores(completionHandler: { [weak self] (_, error) in
            self?.persistentError = error
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()

            } catch {
                let nserror = error as NSError
                persistentError = error
                showError(
                    withTitle: NSLocalizedString("Error", comment: ""),
                    andMessage: "\(NSLocalizedString("DeviceError", comment: "")) \(nserror) \(nserror.userInfo)")
                context.rollback()
            }
        }
    }

    // MARK: - Methods

    func showError(withTitle title: String, andMessage message: String) {
        let rootVC: UIViewController?
        if #available(iOS 13, *) {
            if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
               let window = sceneDelegate.window {
                rootVC = window.rootViewController
            } else {
                rootVC = nil
            }
        } else {
            rootVC = window?.rootViewController
        }
        if let rootVC = rootVC {
            PresenterManager.showMessage(withTitle: title, andMessage: message, byViewController: rootVC)
        }
    }

}
