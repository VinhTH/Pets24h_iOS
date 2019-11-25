//
//  GradientView.swift
//  Pets24h
//
//  Created by Vinh Huynh on 11/25/19.
//  Copyright © 2019 Vinh Huynh. All rights reserved.
//

import UIKit

class GradientView: UIView {
    
    private lazy var gradientLayer = CAGradientLayer()
    
    var colors: [CGColor] = [UIColor.white.cgColor, UIColor.black.cgColor] {
        willSet {
            gradientLayer.colors = newValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addGradient()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addGradient()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateGradient()
    }
    
    private func addGradient() {
        gradientLayer.colors = colors
        layer.addSublayer(gradientLayer)
    }
    
    private func updateGradient() {
        gradientLayer.frame = bounds
    }
}
