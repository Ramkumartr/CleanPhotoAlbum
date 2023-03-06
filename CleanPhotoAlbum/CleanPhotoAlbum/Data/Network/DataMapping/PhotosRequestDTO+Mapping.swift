//
//  PhotosRequestDTO+Mapping.swift
//  CleanPhotoAlbum
//
//  Created by Ramkumar Thiyyakat on 27/02/23.
//

import Foundation

struct PhotosRequestDTO: Encodable {
    let page: String
    let limit: String
}
