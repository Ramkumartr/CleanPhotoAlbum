//
//  UseCase.swift
//  CleanPhotoAlbum
//
//  Created by Ramkumar Thiyyakat on 27/02/23.
//

import Foundation

public protocol UseCase {
    @discardableResult
    func start() -> Cancellable?
}
