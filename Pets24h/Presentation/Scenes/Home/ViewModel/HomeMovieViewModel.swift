//
//  HomeMovieViewModel.swift
//  Pets24h
//
//  Created by Vinh Huynh on 12/23/19.
//

import Foundation.NSData

protocol HomeMovieViewModelInput {
    func updatePosterImage(width: Int)
}

protocol HomeMovieViewModelOutput {
    var title: String { get }
    var posterPath: String? { get }
    var posterImage: Observable<Data?> { get }
}

protocol HomeMovieViewModel: HomeMovieViewModelOutput, HomeMovieViewModelInput { }

final class DefaultHomeMovieViewModel: HomeMovieViewModel {
    /// MARK: OUTPUT
    let title: String
    let posterPath: String?
    let posterImage: Observable<Data?> = Observable(nil)
    
    private let posterImageRepository: PosterImagesRepository
    private var imageLoadTask: Cancelable? { willSet { imageLoadTask?.cancel() }}
    
    init(movie: Movie, posterImageRepository: PosterImagesRepository) {
        self.title = movie.title
        self.posterPath = movie.posterPath
        self.posterImageRepository = posterImageRepository
    }
    
    /// MARK: INPUT
    func updatePosterImage(width: Int) {
        posterImage.value = nil
        guard let posterPath = posterPath else { return }
        imageLoadTask = posterImageRepository.image(with: posterPath, width: width) { [weak self] result in
            switch result {
            case .success(let data):
                self?.posterImage.value = data
            case .failure(let error):
                print("Loading image error: \(error.localizedDescription)")
            }
            self?.imageLoadTask = nil
        }
    }
}
