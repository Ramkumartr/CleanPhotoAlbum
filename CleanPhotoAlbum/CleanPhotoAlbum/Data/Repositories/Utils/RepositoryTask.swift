//
//  RepositoryTask.swift
//  CleanPhotoAlbum
//
//  Created by Ramkumar Thiyyakat on 28/02/23.
//

import Foundation
class RepositoryTask: Cancellable {
    var networkTask: NetworkCancellable?
    var isCancelled: Bool = false
    
    func cancel() {
        networkTask?.cancel()
        isCancelled = true
    }
}
