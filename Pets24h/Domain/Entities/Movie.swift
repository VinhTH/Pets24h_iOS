//
//  Movie.swift
//  Pets24h
//
//  Created by Vinh Huynh on 12/18/19.
//

import Foundation.NSDate

struct MoviesPage {
    let page: Int
    let totalPages: Int
    let movies: [Movie]
}

struct Movie {
    let id: Int
    let title: String
    let posterPath: String?
    let overview: String?
    let releaseDate: Date?
}
