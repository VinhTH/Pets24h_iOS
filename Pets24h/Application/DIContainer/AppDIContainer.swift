//
//  AppDIContainer.swift
//  Pets24h
//
//  Created by Vinh Huynh on 11/20/19.
//

import Foundation

final class AppDIContainer {
    
    lazy var appConfigurations = AppConfigurations()
    
    // MARK: Network
    private lazy var apiDataTransferService: DataTransfer = {
        let config = ApiDataNetworkConfig(baseURL: URL(string: appConfigurations.apiBaseURL)!,
                                          queryParameters: ["api_key": appConfigurations.apiKey])
        let networkService = DefaultNetworkService(session: URLSession.shared, config: config)
        return DefaultDataTransferService(networkService: networkService)
    }()
    
    private lazy var imageDataTransferService: DataTransfer = {
        let config = ApiDataNetworkConfig(baseURL: URL(string: appConfigurations.imageBaseURL)!)
        let networkService = DefaultNetworkService(session: URLSession.shared, config: config)
        return DefaultDataTransferService(networkService: networkService)
    }()
    
    // MARK: DIContainer of scenes
    func makeHomeSceneDIContainer() -> HomeSceneDIContainer {
        let dependencies = HomeSceneDIContainer.Dependencies(apiDataTransferService: apiDataTransferService,
                                                             imageDataTransferService: imageDataTransferService)
        return HomeSceneDIContainer(dependencies: dependencies)
    }
}
