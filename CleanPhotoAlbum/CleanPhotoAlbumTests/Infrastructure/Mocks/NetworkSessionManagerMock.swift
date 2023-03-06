//
//  NetworkSessionManagerMock.swift
//  CleanPhotoAlbumTests
//
//  Created by Ramkumar Thiyyakat on 03/03/23.
//

import Foundation

struct NetworkSessionManagerMock: NetworkSessionManager {
    let response: HTTPURLResponse?
    let data: Data?
    let error: Error?
    
    func request(_ request: URLRequest,
                 completion: @escaping CompletionHandler) -> NetworkCancellable {
        completion(data, response, error)
       // return URLSessionDataTask()
        return URLSessionTask()
    }
}
