//
//  StoryboardInstantiable.swift
//  Pets24h
//
//  Created by Vinh Huynh on 11/20/19.
//  Copyright © 2019 Vinh Huynh. All rights reserved.
//

import UIKit

protocol StoryboardInstantiable {
    associatedtype T
    static func instantiateViewController(bundle: Bundle?) -> T
}

extension StoryboardInstantiable where Self: UIViewController {
    static func instantiateViewController(bundle: Bundle? = nil) -> Self {
        let identifier = String(describing: Self.self)
        let storyboard = UIStoryboard(name: identifier, bundle: bundle)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: identifier) as? Self else {
            fatalError("Unable to instantiate initial view controller \(Self.self) from storyboard with name \(identifier)")
        }
        return viewController
    }
}
