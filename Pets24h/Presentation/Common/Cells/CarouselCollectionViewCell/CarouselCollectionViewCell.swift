//
//  CarouselCollectionViewCell.swift
//  Pets24h
//
//  Created by Vinh Huynh on 11/22/19.
//  Copyright © 2019 Vinh Huynh. All rights reserved.
//

import UIKit

class CarouselCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var posterImage: UIImageView!
    
    private var viewModel: HomeMovieViewModel! { didSet { unbind(from: oldValue) }}
    
    override func awakeFromNib() {
        super.awakeFromNib()
        posterImage.image = nil
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImage.image = nil
    }
    
    func fill(with viewModel: HomeMovieViewModel) {
        self.viewModel = viewModel
        bind(to: viewModel)
        viewModel.updatePosterImage(width: Int(posterImage.bounds.width * UIScreen.main.scale))
    }
    
    private func bind(to viewModel: HomeMovieViewModel) {
        viewModel.posterImage.observer(on: self) { [weak self] data in
            self?.posterImage.image = data.flatMap { UIImage(data: $0) }
        }
    }
    
    private func unbind(from viewModel: HomeMovieViewModel?) {
        viewModel?.posterImage.remove(observer: self)
    }
}
