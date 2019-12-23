//
//  MoviesRepositoryInterfaces.swift
//  Pets24h
//
//  Created by Vinh Huynh on 12/18/19.
//  Copyright © 2019 Vinh Huynh. All rights reserved.
//

protocol MoviesRepository {
    func moviesList(query: MovieQuery, page: Int, completion: @escaping (Result<MoviesPage, Error>) -> Void) -> Cancelable?
}
