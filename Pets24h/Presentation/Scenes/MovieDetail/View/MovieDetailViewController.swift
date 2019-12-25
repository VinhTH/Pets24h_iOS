//
//  MovieDetailViewController.swift
//  Pets24h
//
//  Created by Vinh Huynh on 12/25/19.
//

import UIKit

final class MovieDetailViewController: UIViewController, StoryboardInstantiable {
    
    private(set) var viewModel: MovieDetailViewModel!
    
    final class func create(with viewModel: MovieDetailViewModel) -> MovieDetailViewController {
        let view = MovieDetailViewController.instantiateViewController()
        view.viewModel = viewModel
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Movie Detail"
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        }
    }
}
