//
//  AppDelegate.swift
//  CleanPhotoAlbum
//
//  Created by Ramkumar Thiyyakat on 25/02/23.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let appDIContainer = AppDIContainer()
    var appFlowCoordinator: AppFlowCoordinator?
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        AppAppearance.setupAppearance()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = UINavigationController()
        
        window?.rootViewController = navigationController
        appFlowCoordinator = AppFlowCoordinator(router: RouterImp(rootController: navigationController),
                                                appDIContainer: appDIContainer)
        appFlowCoordinator?.start()
        window?.makeKeyAndVisible()
        
        return true
    }
    
    //    func applicationDidEnterBackground(_ application: UIApplication) {
    //        CoreDataStorage.shared.saveContext()
    //    }
    
    class func sharedInstance() -> AppDelegate {
        UIApplication.shared.delegate as! AppDelegate
    }
}
