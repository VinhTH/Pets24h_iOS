//
//  HomeViewModel.swift
//  Pets24h
//
//  Created by Vinh Huynh on 12/17/19.
//

import Foundation

enum HomeViewModelRoute {
    case initial
    case showMovieDetail(title: String)
}

protocol HomeViewModelInput {
    func viewDidLoad()
    func didSelect(movie: HomeMovieViewModel)
}

protocol HomeViewModelOutput {
    var error: Observable<String> { get }
    var route: Observable<HomeViewModelRoute> { get }
    var items: Observable<[HomeCatagoryViewModel]> { get }
}

protocol HomeViewModel: HomeViewModelInput, HomeViewModelOutput {}

final class DefaultHomeViewModel: HomeViewModel {
    
    private lazy var categories = [
        "Action",
        "Romance",
        "Adventure",
        "Animation",
        "Drama",
        "Horror",
        "Music"
    ]
    
    // MARK: OUTPUT
    let error: Observable<String> = Observable("")
    let route: Observable<HomeViewModelRoute> = Observable(.initial)
    let items: Observable<[HomeCatagoryViewModel]> = Observable([HomeCatagoryViewModel]())
    
    private let searchMoviesUseCase: SearchMoviesUseCase
    private let posterImagesRepository: PosterImagesRepository
    
    init(searchMoviesUseCase: SearchMoviesUseCase,
         posterImagesRepository: PosterImagesRepository) {
        
        self.searchMoviesUseCase = searchMoviesUseCase
        self.posterImagesRepository = posterImagesRepository
    }
}

// MARK: Func
extension DefaultHomeViewModel {
    private func loadCategories() {
        var unsortedItems: [HomeCatagoryViewModel] = []
        let group = DispatchGroup()
        
        for category in categories {
            group.enter()
            let moviesRequest = SearchMoviesUseCaseRequestValue(query: MovieQuery(query: category), page: 1)
            searchMoviesUseCase.execute(requestValue: moviesRequest) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let moviesPage):
                    let movies = moviesPage.movies.map({ DefaultHomeMovieViewModel(movie: $0, posterImageRepository: self.posterImagesRepository) })
                    let categoryViewModel = DefaultHomeCatagoryViewModel(title: category, movies: movies, selectBlock: { [weak self] movieViewModel in
                        self?.didSelect(movie: movieViewModel)
                    })
                    unsortedItems.append(categoryViewModel)
                case .failure(let error):
                    self.handleLoadingCategoryError(error, title: category)
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            self?.items.value = unsortedItems.sorted(by: { $0.title < $1.title })
        }
    }
    
    private func handleLoadingCategoryError(_ error: Error, title: String) {
        self.error.value = NSLocalizedString("Failed loading \(title) genre", comment: "")
    }
}

// MARK: Input
extension DefaultHomeViewModel {
    func viewDidLoad() {
        loadCategories()
    }
    
    func didSelect(movie: HomeMovieViewModel) {
        route.value = .showMovieDetail(title: movie.title)
    }
}
