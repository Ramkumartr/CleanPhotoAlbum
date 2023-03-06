//
//  DefaultFavouritePhotosRepository.swift
//  CleanPhotoAlbum
//
//  Created by Ramkumar Thiyyakat on 02/03/23.
//

import Foundation

final class DefaultFavouritePhotosRepository {
    
    private var favouritePhotosStorage: FavouritePhotosStorage
    
    init(favouritePhotosStorage: FavouritePhotosStorage) {
        self.favouritePhotosStorage = favouritePhotosStorage
    }
}

extension DefaultFavouritePhotosRepository: FavouritePhotosRepository {
    func getFavouritePhotos(completion: @escaping (Result<PhotoModelList?, Error>) -> Void) {
        favouritePhotosStorage.getFavouritePhotos(completion: completion)
    }
    
    func saveFavouritePhoto(photo: PhotoModel, completion: @escaping (Result<PhotoModel, Error>) -> Void) {
        favouritePhotosStorage.saveFavouritePhoto(photo: photo, completion: completion)
    }
    
    func deleteFavouritePhoto(photo: PhotoModel, completion: @escaping (Result<PhotoModel, Error>) -> Void) {
        favouritePhotosStorage.deleteFavouritePhoto(photo: photo, completion: completion)
    }
    
    func checkFavouritePhoto(photo: PhotoModel, completion: @escaping (Result<Bool, Error>) -> Void) {
        favouritePhotosStorage.checkFavouritePhoto(photo: photo, completion: completion)
    }

    
}
