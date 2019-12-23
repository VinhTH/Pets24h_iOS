//
//  Movies+Decodable.swift
//  Pets24h
//
//  Created by Vinh Huynh on 12/23/19.
//

import Foundation

extension MoviesPage: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case page
        case totalPages = "total_pages"
        case movies = "results"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.page = try container.decode(Int.self, forKey: .page)
        self.totalPages = try container.decode(Int.self, forKey: .totalPages)
        self.movies = try container.decode([Movie].self, forKey: .movies)
    }
}

extension Movie: Decodable {
    
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case posterPath = "poster_path"
        case overview
        case releaseDate = "release_date"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath)
        self.overview = try container.decode(String.self, forKey: .overview)
        let releaseDateString = try container.decode(String.self, forKey: .releaseDate)
        self.releaseDate = DateFormatter.yyyyMMdd.date(from: releaseDateString)
    }
}

fileprivate extension DateFormatter {
    static let yyyyMMdd: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
}
