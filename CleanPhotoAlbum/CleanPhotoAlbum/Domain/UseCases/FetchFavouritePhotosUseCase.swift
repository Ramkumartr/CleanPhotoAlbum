//
//  FetchFavouritePhotosUseCase.swift
//  CleanPhotoAlbum
//
//  Created by Ramkumar Thiyyakat on 02/03/23.
//

import Foundation

protocol FetchFavouritePhotosUseCase {
    
    func getFavouritePhotos(completion: @escaping (Result<PhotoModelList?, Error>) -> Void)
    func saveFavouritePhoto(photo: PhotoModel, completion: @escaping (Result<PhotoModel, Error>) -> Void)
    func deleteFavouritePhoto(photo: PhotoModel, completion: @escaping (Result<PhotoModel, Error>) -> Void)
    func checkFavouritePhoto(photo: PhotoModel, completion: @escaping (Result<Bool, Error>) -> Void)
}

final class DefaultFetchFavouritePhotosUseCase: FetchFavouritePhotosUseCase {
    
    private let favouritePhotosRepository: FavouritePhotosRepository
    
    init(favouritePhotosRepository: FavouritePhotosRepository) {
        self.favouritePhotosRepository = favouritePhotosRepository
    }
    
    func getFavouritePhotos(completion: @escaping (Result<PhotoModelList?, Error>) -> Void) {
        favouritePhotosRepository.getFavouritePhotos(completion: completion)
    }
    
    func saveFavouritePhoto(photo: PhotoModel, completion: @escaping (Result<PhotoModel, Error>) -> Void) {
        favouritePhotosRepository.saveFavouritePhoto(photo: photo, completion: completion)
    }
    
    func deleteFavouritePhoto(photo: PhotoModel, completion: @escaping (Result<PhotoModel, Error>) -> Void){
        favouritePhotosRepository.deleteFavouritePhoto(photo: photo, completion: completion)
    }
    
    func checkFavouritePhoto(photo: PhotoModel, completion: @escaping (Result<Bool, Error>) -> Void) {
        favouritePhotosRepository.checkFavouritePhoto(photo: photo, completion: completion)
    }
}


