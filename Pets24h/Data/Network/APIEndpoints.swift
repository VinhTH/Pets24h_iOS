//
//  APIEndpoints.swift
//  Pets24h
//
//  Created by Vinh Huynh on 12/19/19.
//

struct APIEndpoints {
    static func movies(query: String, page: Int) -> DataEndpoint<MoviesPage> {
        return DataEndpoint(path: "3/search/movie/", queryParameters: ["query": query,
                                                                   "page": page])
    }
}
