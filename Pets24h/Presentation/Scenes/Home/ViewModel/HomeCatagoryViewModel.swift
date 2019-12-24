//
//  HomeCatagoryViewModel.swift
//  Pets24h
//
//  Created by Vinh Huynh on 12/23/19.
//

protocol HomeCatagoryViewModel {
    var title: String { get }
    var subtitle: String { get }
    var items: [HomeMovieViewModel] { get }
}

final class DefaultHomeCatagoryViewModel: HomeCatagoryViewModel {
    
    let title: String
    var subtitle: String
    let items: [HomeMovieViewModel]
    
    init(title: String, movies: [HomeMovieViewModel]) {
        self.title = title
        self.subtitle = title
        self.items = movies
    }
}
