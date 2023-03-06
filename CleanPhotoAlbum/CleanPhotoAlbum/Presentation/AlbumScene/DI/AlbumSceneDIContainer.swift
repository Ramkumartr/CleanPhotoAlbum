//
//  AlbumSceneDIContainer.swift
//  CleanPhotoAlbum
//
//  Created by Ramkumar Thiyyakat on 01/03/23.
//

import Foundation

final class AlbumSceneDIContainer {
    
    struct Dependencies {
        let apiDataTransferService: DataTransferService
    }
    
    private let dependencies: Dependencies
    
    // MARK: - Persistent Storage
       lazy var favouritePhotosStorage: FavouritePhotosStorage = CoreDataFavouritePhotosStorage()
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    // MARK: - Use Cases
    func makeFetchPhotosUseCase() -> FetchPhotosUseCase {
        return DefaultFetchPhotosUseCase(photosListRepository: makePhotosListRepository())
    }
    
    func makeFetchFavouritePhotosUseCase() -> FetchFavouritePhotosUseCase {
        return DefaultFetchFavouritePhotosUseCase(favouritePhotosRepository: makeFavouritePhotosRepository())
    }
    
    // MARK: - Repositories
    func makePhotosListRepository() -> PhotosListRepository {
        return DefaultPhotosListRepository(dataTransferService: dependencies.apiDataTransferService)
    }
    
    
    func makeFavouritePhotosRepository() -> FavouritePhotosRepository {
        return DefaultFavouritePhotosRepository(favouritePhotosStorage: favouritePhotosStorage)
    }
    
    // MARK: - Album
    
    func makeAlbumViewController(actions: AlbumViewModelActions) -> AlbumViewController {
        
        AlbumViewController.create(with: makeAlbumViewModel(actions: actions))
    }
    
    func makeAlbumViewModel(actions: AlbumViewModelActions) -> AlbumViewModel {
        return DefaultAlbumViewModel(fetchPhotosUseCase: makeFetchPhotosUseCase(),
                                     actions: actions)
    }
    
    // MARK: - Album Favourite
    func makeFavouriteAlbumViewController(actions: AlbumViewModelActions) -> AlbumViewController {
        
        AlbumViewController.create(with: makeFavouriteAlbumViewModel(actions: actions))
    }
    
    func makeFavouriteAlbumViewModel(actions: AlbumViewModelActions) -> AlbumViewModel {
        return DefaultAlbumViewModel(actions: actions, fetchFavouritePhotosUseCase: makeFetchFavouritePhotosUseCase())
    }
    
    
    // MARK: - Photo Details
    func makePhotoDetailViewController(image: PhotoItemModel, actions: PhotoDetailViewModelActions) -> PhotoDetailViewController {
        PhotoDetailViewController.create(with: makePhotoDetailViewModel(image: image, actions: actions))
        
    }
    
    func makePhotoDetailViewModel(image: PhotoItemModel, actions: PhotoDetailViewModelActions) -> PhotoDetailViewModel {
        return DefaultPhotoDetailViewModel(photo: image, actions: actions, fetchFavouritePhotosUseCase: makeFetchFavouritePhotosUseCase())
    }
    
    
    // MARK: - Flow Coordinators
    func makeAlbumFlowCoordinator(router: Router) -> AlbumFlowCoordinator {
        return AlbumFlowCoordinator(router: router,
                                    dependencies: self)
    }
}

extension AlbumSceneDIContainer: AlbumFlowCoordinatorDependencies {}
