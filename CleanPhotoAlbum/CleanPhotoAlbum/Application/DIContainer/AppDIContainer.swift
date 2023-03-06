//
//  AppDIContainer.swift
//  CleanPhotoAlbum
//
//  Created by Ramkumar Thiyyakat on 25/02/23.
//

import Foundation

final class AppDIContainer {
    
    lazy var appConfiguration = AppConfiguration()
    
    // MARK: - Network
    
    
    lazy var apiDataTransferService: DataTransferService = {
        let config = ApiDataNetworkConfig(baseURL: URL(string: appConfiguration.apiBaseURL)!)
        
        let apiDataNetwork = DefaultNetworkService(config: config)
        return DefaultDataTransferService(with: apiDataNetwork)
    }()
    
//    lazy var apiDataTransferService: DataTransferService = {
//        let config = ApiDataNetworkConfig(baseURL: URL(string: appConfiguration.apiBaseURL)!,
//                                          queryParameters: ["api_key": appConfiguration.apiKey,
//                                                            "language": NSLocale.preferredLanguages.first ?? "en"])
//
//        let apiDataNetwork = DefaultNetworkService(config: config)
//        return DefaultDataTransferService(with: apiDataNetwork)
//    }()
//
//    lazy var imageDataTransferService: DataTransferService = {
//        let config = ApiDataNetworkConfig(baseURL: URL(string: appConfiguration.imagesBaseURL)!)
//        let imagesDataNetwork = DefaultNetworkService(config: config)
//        return DefaultDataTransferService(with: imagesDataNetwork)
//    }()
    
    // MARK: - DIContainers of scenes
 
    
    func makeTabBarDIContainer() -> TabBarDIContainer {
        let dependencies = TabBarDIContainer.Dependencies(apiDataTransferService: apiDataTransferService)
        return TabBarDIContainer(dependencies: dependencies)
    }
}
