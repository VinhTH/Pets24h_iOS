//
//  APIEndpoints.swift
//  Pets24h
//
//  Created by Vinh Huynh on 12/19/19.
//

import Foundation.NSData

struct APIEndpoints {
    static func movies(query: String, page: Int) -> DataEndpoint<MoviesPage> {
        return DataEndpoint(path: "3/search/movie/", queryParameters: ["query": query,
                                                                   "page": page])
    }
    
    static func moviePoster(path: String, width: Int) -> DataEndpoint<Data> {
        let sizes = [92, 185, 500, 780]
        let availableWidth = sizes.first { $0 <= width } ?? sizes.last
        return DataEndpoint(path: "t/p/w\(availableWidth!)\(path)")
    }
}
