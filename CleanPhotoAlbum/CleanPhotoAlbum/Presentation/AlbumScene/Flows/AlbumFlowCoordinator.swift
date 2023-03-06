//
//  AlbumFlowCoordinator.swift
//  CleanPhotoAlbum
//
//  Created by Ramkumar Thiyyakat on 01/03/23.
//

import Foundation

protocol AlbumFlowCoordinatorDependencies  {
    func makeAlbumViewController(actions: AlbumViewModelActions) -> AlbumViewController
    func makePhotoDetailViewController(image: PhotoItemModel, actions: PhotoDetailViewModelActions) -> PhotoDetailViewController
    func makeFavouriteAlbumViewController(actions: AlbumViewModelActions) -> AlbumViewController
}

final class AlbumFlowCoordinator {
 
    private let router: Router?
    private let dependencies: AlbumFlowCoordinatorDependencies

    private weak var albumViewController: AlbumViewController?
    private weak var photoDetailViewController: PhotoDetailViewController?

    init(router: Router,
         dependencies: AlbumFlowCoordinatorDependencies) {
        self.router = router
        self.dependencies = dependencies
    }
    
    func start() {
        // Note: here we keep strong reference with actions, this way this flow do not need to be strong referenced
        let actions = AlbumViewModelActions(showPhotoDetails: showPhotoDetails)
        let vc = dependencies.makeAlbumViewController(actions: actions)
        router?.push(vc, animated: true)
        albumViewController = vc
    }
    
    func startFavourite() {
        // Note: here we keep strong reference with actions, this way this flow do not need to be strong referenced
        let actions = AlbumViewModelActions(showPhotoDetails: showPhotoDetails)
        let vc = dependencies.makeFavouriteAlbumViewController(actions: actions)
        router?.push(vc, animated: true)
        albumViewController = vc
    }
    

    private func showPhotoDetails(photo: PhotoItemModel) {
        let actions = PhotoDetailViewModelActions(backAction: backAction)
        let vc = dependencies.makePhotoDetailViewController(image: photo, actions: actions)
        router?.push(vc, hideBottomBar: true)
    }


    private func backAction() {
        router?.popModule()
    }
}
