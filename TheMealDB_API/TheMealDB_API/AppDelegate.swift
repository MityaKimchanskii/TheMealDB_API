//
//  AppDelegate.swift
//  TheMealDB_API
//
//  Created by Mitya Kim on 4/7/23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.backgroundColor = .systemBackground
//        window?.rootViewController = ViewController()
//        window?.rootViewController = LoginViewController()
//        window?.rootViewController = MealListViewController()
        
//        let mealvc = MealListViewController()
//        let navigationVC = UINavigationController(rootViewController: mealvc)
//
//        window?.rootViewController = navigationVC
        
//        window?.rootViewController = CategoryListViewController()
        
        let categoryVC = CategoryListViewController()
        let navigationVC = UINavigationController(rootViewController: categoryVC)
        window?.rootViewController = navigationVC
        
        return true
    }
}

