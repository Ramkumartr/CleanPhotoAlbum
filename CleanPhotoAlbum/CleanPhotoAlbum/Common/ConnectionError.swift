//
//  ConnectionError.swift
//  CleanPhotoAlbum
//
//  Created by Ramkumar Thiyyakat on 27/02/23.
//

import Foundation

public protocol ConnectionError: Error {
    var isInternetConnectionError: Bool { get }
}

public extension Error {
    var isInternetConnectionError: Bool {
        guard let error = self as? ConnectionError, error.isInternetConnectionError else {
            return false
        }
        return true
    }
}
