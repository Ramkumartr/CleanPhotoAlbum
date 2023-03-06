//
//  NetworkConfigurableMock.swift
//  CleanPhotoAlbumTests
//
//  Created by Ramkumar Thiyyakat on 03/03/23.
//

import Foundation

class NetworkConfigurableMock: NetworkConfigurable {
    var baseURL: URL = URL(string: "https://mock.test.com")!
    var headers: [String: String] = [:]
    var queryParameters: [String: String] = [:]
}
