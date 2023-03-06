//
//  FetchPhotosUseCase.swift
//  CleanPhotoAlbum
//
//  Created by Ramkumar Thiyyakat on 27/02/23.
//

import Foundation

protocol FetchPhotosUseCase {
    func execute(requestValue: FetchPhotosUseCaseRequestValue,
                 completion: @escaping (Result<PhotoModelList, Error>) -> Void) -> Cancellable?
}

final class DefaultFetchPhotosUseCase: FetchPhotosUseCase {
    
    private let photosListRepository: PhotosListRepository
    
    init(photosListRepository: PhotosListRepository) {
        
        self.photosListRepository = photosListRepository
    }
    
    func execute(requestValue: FetchPhotosUseCaseRequestValue,
                 completion: @escaping (Result<PhotoModelList, Error>) -> Void) -> Cancellable? {
        
        return photosListRepository.fetchPhotosList(query: requestValue.query,
                                                    completion: { result in
            
            
            completion(result)
        })
    }
}

struct FetchPhotosUseCaseRequestValue {
    let query: PhotoListQueryModel
}
