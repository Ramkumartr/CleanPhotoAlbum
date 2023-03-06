//
//  PhotoModel.swift
//  CleanPhotoAlbum
//
//  Created by Ramkumar Thiyyakat on 27/02/23.
//

import Foundation

struct PhotoModel: Equatable {
    let id: String
    let author: String
    let download_url: String
    let url: String
    let width: Int
    let height: Int
}

typealias PhotoModelList = [PhotoModel]
