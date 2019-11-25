//
//  UICollectionView+Pets24h.swift
//  Pets24h
//
//  Created by Vinh Huynh on 11/22/19.
//  Copyright © 2019 Vinh Huynh. All rights reserved.
//

import UIKit

extension UICollectionView {
    func register(cell type: UICollectionViewCell.Type, bundle: Bundle? = nil) {
        let identifier = String(describing: type)
        register(UINib(nibName: identifier, bundle: bundle), forCellWithReuseIdentifier: identifier)
    }
    
    func dequeueReusableCell(withType cellType: UICollectionViewCell.Type, for indexPath: IndexPath) -> UICollectionViewCell {
        return dequeueReusableCell(withReuseIdentifier: String(describing: cellType), for: indexPath)
    }
}
