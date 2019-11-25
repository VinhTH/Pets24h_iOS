//
//  CategoryTableViewCell.swift
//  Pets24h
//
//  Created by Vinh Huynh on 11/21/19.
//  Copyright © 2019 Vinh Huynh. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var gradientView: GradientView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var viewAllButton: UIButton!
    
    private var category = HomeCategory() {
        willSet {
            titleLabel.text = newValue.title
            subtitleLabel.text = newValue.subtitle
            viewAllButton.isHidden = !newValue.isViewableAll
            collectionView.reloadData()
            gradientView.colors = newValue.colors.map({
                UIColor(hex: $0).cgColor
            })
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        category = HomeCategory()
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(cell: CarouselCollectionViewCell.self)
        collectionView.reloadData()
    }
    
    func reloadCell(withCategory category: HomeCategory) {
        self.category = category
    }
}

// MARK: UICollectionViewDatasource
extension CategoryTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return category.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withType: CarouselCollectionViewCell.self, for: indexPath) as? CarouselCollectionViewCell else {
            fatalError("Unable to dequeue reusable cell \(CarouselCollectionViewCell.self)")
        }
        return cell
    }
}

// MARK:
extension CategoryTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 115*16/9, height: 115)
    }
}
