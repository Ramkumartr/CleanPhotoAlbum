//
//  TabBarFlowCoordinator.swift
//  CleanPhotoAlbum
//
//  Created by Ramkumar Thiyyakat on 01/03/23.
//

import Foundation
import UIKit

protocol TabBarFlowCoordinatorDependencies  {
    func makeTabBarController() -> TabBarController
    func makeAlbumSceneDIContainer() -> AlbumSceneDIContainer
}

final class TabBarFlowCoordinator {
    
    private let router: Router
    private let dependencies: TabBarFlowCoordinatorDependencies
    
    weak var taBarController: TabBarController?
    
    init(router: Router, dependencies: TabBarFlowCoordinatorDependencies) {
        self.router = router
        self.dependencies = dependencies
    }
    
    func start() {
        
        taBarController = dependencies.makeTabBarController()
        
        // 1st Tab
        let albumNav1 = createNavController( title: NSLocalizedString("Gallery", comment: ""), image: UIImage(systemName: "magnifyingglass")!)
        let router1 = RouterImp(rootController: albumNav1)
        let albumSceneDIContainer = dependencies.makeAlbumSceneDIContainer()
        let albumFlow1 = albumSceneDIContainer.makeAlbumFlowCoordinator(router: router1)
        
        // 2nd Tab
        let albumNav2 = createNavController( title: NSLocalizedString("Favourites", comment: ""), image: UIImage(systemName: "house")!)
        let router2 = RouterImp(rootController: albumNav2)
        let albumSceneDIContainer2 = dependencies.makeAlbumSceneDIContainer()
        let albumFlow2 = albumSceneDIContainer2.makeAlbumFlowCoordinator(router: router2)
        
        
        taBarController?.viewControllers = [albumNav1, albumNav2]
        taBarController?.modalPresentationStyle = .fullScreen
        AppDelegate.sharedInstance().window?.rootViewController = taBarController
        AppDelegate.sharedInstance().window?.makeKeyAndVisible()
    
        albumFlow1.start()
        albumFlow2.startFavourite()
    }
}

fileprivate func createNavController(title: String,
                                     image: UIImage) -> UINavigationController {
    let navController = UINavigationController()
    navController.tabBarItem.title = title
    navController.tabBarItem.image = image
  //  navController.navigationBar.prefersLargeTitles = false
    
   // navController.navigationBar.barTintColor = .white
  //  navController.navigationBar.isTranslucent = true
    
   // rootViewController.navigationItem.title = title
    return navController
}
