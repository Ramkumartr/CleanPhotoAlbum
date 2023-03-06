//
//  APIEndpoints.swift
//  CleanPhotoAlbum
//
//  Created by Ramkumar Thiyyakat on 27/02/23.
//

import Foundation

struct APIEndpoints {
    
    static func getPhotosList(with photosRequestDTO: PhotosRequestDTO) -> Endpoint<PhotosListResponseDTO> {

        return Endpoint(path: "/list",
                        method: .get,
                        queryParametersEncodable: photosRequestDTO)
    }
   
}
