//
//  TabBarDIContainer.swift
//  CleanPhotoAlbum
//
//  Created by Ramkumar Thiyyakat on 01/03/23.
//

import Foundation

final class TabBarDIContainer {
    
    struct Dependencies {
        let apiDataTransferService: DataTransferService
    }
    
    private let dependencies: Dependencies
    
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    
    // MARK: - Flow Coordinators
    func makeATabBarFlowCoordinator(router: Router) -> TabBarFlowCoordinator {
        return TabBarFlowCoordinator(router: router,
                                    dependencies: self)
    }
    
}

extension TabBarDIContainer: TabBarFlowCoordinatorDependencies {
    func makeTabBarController() -> TabBarController {
        TabBarController.create()
    }
    
    func makeAlbumSceneDIContainer() -> AlbumSceneDIContainer {
        let dependencies = AlbumSceneDIContainer.Dependencies(apiDataTransferService: dependencies.apiDataTransferService)
        return  AlbumSceneDIContainer(dependencies: dependencies)
    }
    
}
