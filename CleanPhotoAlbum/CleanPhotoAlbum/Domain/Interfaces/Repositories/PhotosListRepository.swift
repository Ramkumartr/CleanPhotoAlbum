//
//  PhotosListRepository.swift
//  CleanPhotoAlbum
//
//  Created by Ramkumar Thiyyakat on 27/02/23.
//

import Foundation

protocol PhotosListRepository {
    @discardableResult
    func fetchPhotosList(query: PhotoListQueryModel,
                         completion: @escaping (Result<PhotoModelList, Error>) -> Void) -> Cancellable?
}
