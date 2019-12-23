//
//  HomeSceneDIContainer.swift
//  Pets24h
//
//  Created by Vinh Huynh on 11/20/19.
//

import UIKit

final class HomeSceneDIContainer {
    
    struct Dependencies {
        let apiDataTransferService: DataTransfer
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func makeHomeViewController() -> UIViewController {
        return HomeViewController.create(with: makeHomeViewModel())
    }
    
    private func makeHomeViewModel() -> HomeViewModel {
        return DefaultHomeViewModel(searchMoviesUseCase: makeSearchMoviesUseCase())
    }
    
    private func makeSearchMoviesUseCase() -> SearchMoviesUseCase {
        return DefaultSeachMoviesUseCase(moviesRepository: makeMoviesRepository())
    }
    
    private func makeMoviesRepository() -> MoviesRepository {
        return DefaultMoviesRepository(dataTransferService: dependencies.apiDataTransferService)
    }
}
