//
//  PhotosResponseDTO+Mapping.swift
//  CleanPhotoAlbum
//
//  Created by Ramkumar Thiyyakat on 27/02/23.
//

import Foundation

// MARK: - Data Transfer Object

typealias PhotosListResponseDTO = [PhotosResponseDTO]

struct PhotosResponseDTO: Decodable {
    let id: String
    let author: String
    let download_url: String
    let url: String
    let width: Int
    let height: Int
}


// MARK: - Mappings to Domain

extension PhotosListResponseDTO {
    func toDomain() -> PhotoModelList {
        return  self.map { $0.toDomain() }
    }
}

extension PhotosResponseDTO {
    func toDomain() -> PhotoModel {
        return .init(id: id,
                     author: author,
                     download_url: download_url,
                     url: url,
                     width: width,
                     height: height)
    }
}

