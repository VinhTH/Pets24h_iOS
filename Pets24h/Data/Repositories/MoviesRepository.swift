//
//  MoviesRepository.swift
//  Pets24h
//
//  Created by Vinh Huynh on 12/18/19.
//

import Foundation

final class DefaultMoviesRepository: MoviesRepository {
    
    private let dataTransferService: DataTransfer
    
    init(dataTransferService: DataTransfer) {
        self.dataTransferService = dataTransferService
    }
    
    func moviesList(query: MovieQuery, page: Int, completion: @escaping (Result<MoviesPage, Error>) -> Void) -> Cancelable? {
        let endpoint = APIEndpoints.movies(query: query.query, page: page)
        return dataTransferService.request(width: endpoint, completion: completion)
    }
}
