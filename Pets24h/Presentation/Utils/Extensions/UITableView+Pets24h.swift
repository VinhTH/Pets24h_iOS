//
//  UITableView+Pets24h.swift
//  Pets24h
//
//  Created by Vinh Huynh on 11/20/19.
//  Copyright © 2019 Vinh Huynh. All rights reserved.
//

import UIKit

extension UITableView {
    func makeNavigationBarBottomLineHeaderView(horizontalPadding: CGFloat) {
        let topLineWidth = bounds.width - horizontalPadding*2
        let topLine = UIView(frame: CGRect(x: horizontalPadding, y: 0, width: topLineWidth, height: 0.5))
        topLine.backgroundColor = .darkGray50
        let headerContainer = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 0.5))
        headerContainer.backgroundColor = .white
        headerContainer.addSubview(topLine)
        tableHeaderView = headerContainer
    }
}

extension UITableView {
    func register(cell cellType: UITableViewCell.Type, bundle: Bundle? = nil) {
        let identifier = String(describing: cellType)
        register(UINib(nibName: identifier, bundle: bundle), forCellReuseIdentifier: identifier)
    }
    
    func dequeueReusableCell(withType cellType: UITableViewCell.Type, for indexPath: IndexPath) -> UITableViewCell {
        return dequeueReusableCell(withIdentifier: String(describing: cellType), for: indexPath)
    }
}
