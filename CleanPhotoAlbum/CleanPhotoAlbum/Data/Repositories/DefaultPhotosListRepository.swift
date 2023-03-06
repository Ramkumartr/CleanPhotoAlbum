//
//  DefaultPhotosListRepository.swift
//  CleanPhotoAlbum
//
//  Created by Ramkumar Thiyyakat on 27/02/23.
//

import Foundation

final class DefaultPhotosListRepository {

    private let dataTransferService: DataTransferService

    init(dataTransferService: DataTransferService) {
        self.dataTransferService = dataTransferService
    
    }
}

extension DefaultPhotosListRepository: PhotosListRepository {

  public  func fetchPhotosList(query: PhotoListQueryModel,
                         completion: @escaping (Result<PhotoModelList, Error>) -> Void) -> Cancellable? {

      let requestDTO = PhotosRequestDTO(page: query.page, limit: query.limit)
        let task = RepositoryTask()
            guard !task.isCancelled else { return nil}

      let endpoint = APIEndpoints.getPhotosList(with : requestDTO)
            task.networkTask = self.dataTransferService.request(with: endpoint) { result in
                switch result {
                case .success(let responseDTO):
                    completion(.success(responseDTO.toDomain()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        
        return task
    }
}
