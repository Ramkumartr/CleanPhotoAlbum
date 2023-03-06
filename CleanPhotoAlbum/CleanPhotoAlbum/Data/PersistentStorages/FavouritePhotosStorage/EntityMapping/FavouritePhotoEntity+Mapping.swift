//
//  FavouritePhotoEntity+Mapping.swift
//  CleanPhotoAlbum
//
//  Created by Ramkumar Thiyyakat on 02/03/23.
//

import Foundation
import CoreData


extension FavouritePhotoEntity {
    convenience init(photo: PhotoModel, insertInto context: NSManagedObjectContext) {
        self.init(context: context)
        id = photo.id
        author = photo.author
        download_url = photo.download_url
        url = photo.url
        width = Int32(photo.width)
        height = Int32(photo.height)
    }
}

extension FavouritePhotoEntity {
    func toDomain() -> PhotoModel {
        return .init(id: id ?? "",
                     author: author ?? "",
                     download_url: download_url ?? "",
                     url: url ?? "",
                     width: Int(width),
                     height: Int(height))
    }
}
