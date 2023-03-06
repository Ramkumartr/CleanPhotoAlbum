//
//  AppFlowCoordinator.swift
//  CleanPhotoAlbum
//
//  Created by Ramkumar Thiyyakat on 25/02/23.
//

import UIKit

final class AppFlowCoordinator {

   // var navigationController: UINavigationController
    private let router: Router
    private let appDIContainer: AppDIContainer
    
    init(router: Router, appDIContainer: AppDIContainer) {
        self.router = router
        self.appDIContainer = appDIContainer
    }

    func start() {
        // In App Flow we can check if user needs to login, if yes we would run login flow
        let tabBarDIContainer = appDIContainer.makeTabBarDIContainer()
        let flow = tabBarDIContainer.makeATabBarFlowCoordinator(router: router)
        flow.start()
    }
}
