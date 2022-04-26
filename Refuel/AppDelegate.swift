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

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        if #available(iOS 13, *) {
            // The window will be created in the SceneDelegate
        } else {
            
            // Init window only if iOS version below 13.0
            window = UIWindow(frame: UIScreen.main.bounds)
            window?.rootViewController = LoadingController() // MainTabBarController()
            window?.makeKeyAndVisible()
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Refuel")
        container.loadPersistentStores(completionHandler: { [weak self] (storeDescription, error) in
//            if let error = error as NSError? {
            self?.persistentError = error
//            }
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
//                let nserror = error as NSError
//                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                persistentError = error
                showError(withTitle: "Ошибка!", andMessage: "Возникла непредвиденная ошибка при работе с памятью устройства.")
                context.rollback()
            }
        }
    }

    // MARK: - Methods

    func showError(withTitle title: String, andMessage message: String) {
        let rootVC: UIViewController?

        if #available(iOS 13, *) {
            if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate, let window = sceneDelegate.window {
                rootVC = window.rootViewController
            } else {
                rootVC = nil
            }
        } else {
            rootVC = window?.rootViewController
        }

        if let rootVC = rootVC {
            PresenterManager.shared.showMessage(withTitle: title, andMessage: message, byViewController: rootVC)
        }
    }

}

