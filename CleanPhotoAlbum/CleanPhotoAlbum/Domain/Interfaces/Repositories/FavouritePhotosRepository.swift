//
//  FavouritePhotosRepository.swift
//  CleanPhotoAlbum
//
//  Created by Ramkumar Thiyyakat on 02/03/23.
//

import Foundation

protocol FavouritePhotosRepository {
    func getFavouritePhotos(completion: @escaping (Result<PhotoModelList?, Error>) -> Void)
    func saveFavouritePhoto(photo: PhotoModel, completion: @escaping (Result<PhotoModel, Error>) -> Void)
    func deleteFavouritePhoto(photo: PhotoModel, completion: @escaping (Result<PhotoModel, Error>) -> Void)
    func checkFavouritePhoto(photo: PhotoModel, completion: @escaping (Result<Bool, Error>) -> Void)
}
