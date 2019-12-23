//
//  SearchMoviesUseCase.swift
//  Pets24h
//
//  Created by Vinh Huynh on 12/18/19.
//  Copyright © 2019 Vinh Huynh. All rights reserved.
//

protocol SearchMoviesUseCase {
    @discardableResult
    func execute(requestValue: SearchMoviesUseCaseRequestValue,
                 completion: @escaping (Result<MoviesPage, Error>) -> Void) -> Cancelable?
}

final class DefaultSeachMoviesUseCase: SearchMoviesUseCase {
    
    private let moviesRepository: MoviesRepository
    
    init(moviesRepository: MoviesRepository) {
        self.moviesRepository = moviesRepository
    }
    
    func execute(requestValue: SearchMoviesUseCaseRequestValue,
                 completion: @escaping (Result<MoviesPage, Error>) -> Void) -> Cancelable? {
        
        return moviesRepository.moviesList(query: requestValue.query, page: requestValue.page, completion: completion)
    }
}

struct SearchMoviesUseCaseRequestValue {
    let query: MovieQuery
    let page: Int
}
