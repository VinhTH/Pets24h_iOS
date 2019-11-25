//
//  UINavigationBar+CustomUI.swift
//  Pets24h
//
//  Created by Vinh Huynh on 11/20/19.
//  Copyright © 2019 Vinh Huynh. All rights reserved.
//

import UIKit

// MARK: Navigation Style
extension UINavigationBar {
    func makeLargeNavigationBar(_ bottomRightButton: UIButton) {
        isHiddenShadow = true
        layoutMargins.left = 36
        pinToBottomRight(bottomRightButton)
        if #available(iOS 11.0, *) {
            prefersLargeTitles = true
        }
    }
}

// MARK: Custom UI
extension UINavigationBar {
    var isHiddenShadow: Bool {
        get {
            return value(forKey: "hidesShadow") as? Bool ?? true
        }
        
        set {
            setValue(newValue, forKey: "hidesShadow")
        }
    }
    
    fileprivate func pinToBottomRight(_ subview: UIView) {
        
        let navigationBarLargeTitleViewOrNil = subviews.first(where: {
            String(describing: type(of: $0)) == "_UINavigationBarLargeTitleView"
        })
        
        guard let navigationBarLargeTitleView = navigationBarLargeTitleViewOrNil else {
            return
        }
        
        navigationBarLargeTitleView.addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subview.widthAnchor.constraint(equalToConstant: 44),
            subview.heightAnchor.constraint(equalToConstant: 44),
            subview.rightAnchor.constraint(equalTo: navigationBarLargeTitleView.rightAnchor, constant: -36),
            subview.bottomAnchor.constraint(equalTo: navigationBarLargeTitleView.bottomAnchor, constant: -8),
        ])
        
        subview.clipsToBounds = true
        subview.layer.cornerRadius = 22
    }
}
