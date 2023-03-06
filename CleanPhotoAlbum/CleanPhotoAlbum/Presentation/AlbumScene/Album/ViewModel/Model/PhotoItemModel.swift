//
//  PhotoItemModel.swift
//  CleanPhotoAlbum
//
//  Created by Ramkumar Thiyyakat on 28/02/23.
//

import Foundation

struct PhotoItemModel: Equatable  {
    let id: String
    let author: String
    let download_url: String
    let url: String
    let width: Int
    let height: Int
}


extension PhotoItemModel {
    
    init(photoModel: PhotoModel) {
        self.id = photoModel.id
        self.author = photoModel.author
        self.download_url = photoModel.download_url
        self.url = photoModel.url
        self.width = photoModel.width
        self.height = photoModel.height
    }
}


extension PhotoItemModel {
    func toRequestModel() -> PhotoModel {
        return .init(id: id, author: author, download_url: download_url, url: url, width: width, height: height)
    }
    
}
