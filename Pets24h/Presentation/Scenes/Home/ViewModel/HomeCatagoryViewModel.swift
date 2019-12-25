//
//  HomeCatagoryViewModel.swift
//  Pets24h
//
//  Created by Vinh Huynh on 12/23/19.
//

protocol HomeCategoryViewModelInput {
    func didSelect(_ movie: HomeMovieViewModel)
}

protocol HomeCategoryViewModelOutput {
    var title: String { get }
    var subtitle: String { get }
    var items: [HomeMovieViewModel] { get }
    var selectBlock: ((HomeMovieViewModel) -> Void)? { get }
}

protocol HomeCatagoryViewModel: HomeCategoryViewModelOutput, HomeCategoryViewModelInput { }

final class DefaultHomeCatagoryViewModel: HomeCatagoryViewModel {
    
    let title: String
    let subtitle: String
    let items: [HomeMovieViewModel]
    let selectBlock: ((HomeMovieViewModel) -> Void)?
    
    init(title: String,
         movies: [HomeMovieViewModel],
         selectBlock: ((HomeMovieViewModel) -> Void)? = nil) {
        
        self.title = title
        self.subtitle = title
        self.items = movies
        self.selectBlock = selectBlock
    }
    
    func didSelect(_ movie: HomeMovieViewModel) {
        selectBlock?(movie)
    }
}
