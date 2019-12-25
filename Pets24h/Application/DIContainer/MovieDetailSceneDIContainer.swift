//
//  MovieDetailSceneDIContainer.swift
//  Pets24h
//
//  Created by Vinh Huynh on 12/25/19.
//

import UIKit

final class MovieDetailSceneDIContainer {
    func makeMovieDetailViewController() -> UIViewController {
        return MovieDetailViewController.create(with: makeMovieDetailViewModel())
    }
    
    func makeMovieDetailViewModel() -> MovieDetailViewModel {
        return DefaultMovieDetailViewModel()
    }
}
