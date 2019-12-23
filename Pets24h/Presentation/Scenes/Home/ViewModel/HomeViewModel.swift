//
//  HomeViewModel.swift
//  Pets24h
//
//  Created by Vinh Huynh on 12/17/19.
//

import Foundation

protocol HomeViewModelInput {
    func viewDidLoad()
}

protocol HomeViewModel: HomeViewModelInput {}

final class DefaultHomeViewModel: HomeViewModel {
    
    private let searchMoviesUseCase: SearchMoviesUseCase
    
    init(searchMoviesUseCase: SearchMoviesUseCase) {
        self.searchMoviesUseCase = searchMoviesUseCase
    }
}

// MARK: Func
extension DefaultHomeViewModel {
    private func loadCategories() {
        let actionMoviesRequest = SearchMoviesUseCaseRequestValue(query: MovieQuery(query: "Action"), page: 1)
        let trendingMoviesRequest = SearchMoviesUseCaseRequestValue(query: MovieQuery(query: "Trending"), page: 1)
        
        var moviesPages: [MoviesPage] = []
        let group = DispatchGroup()
        group.enter()
        searchMoviesUseCase.execute(requestValue: actionMoviesRequest) { result in
            switch result {
            case .success(let moviesPage):
                moviesPages.append(moviesPage)
                print("Get action movies success:", moviesPage.movies.count)
            case .failure(let error):
                print("Get action movies failed: ", error.localizedDescription)
            }
            group.leave()
        }
        
        group.enter()
        searchMoviesUseCase.execute(requestValue: trendingMoviesRequest) { result in
            switch result {
            case .success(let moviesPage):
                moviesPages.append(moviesPage)
                print("Get trending movies success:", moviesPage.movies.count)
            case .failure(let error):
                print("Get trending movies failed: ", error.localizedDescription)
            }
            group.leave()
        }
        
        group.notify(queue: .main) {
            print("Load categories success:", moviesPages.count)
        }
    }
}

// MARK: Input
extension DefaultHomeViewModel {
    func viewDidLoad() {
        loadCategories()
    }
}
