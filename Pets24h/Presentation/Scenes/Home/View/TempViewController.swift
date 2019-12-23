//
//  TempViewController.swift
//  Pets24h
//
//  Created by Vinh Huynh on 11/20/19.
//  Copyright © 2019 Vinh Huynh. All rights reserved.
//

import UIKit

class TempViewController: UIViewController, StoryboardInstantiable {
    final class func create() -> TempViewController {
        return TempViewController.instantiateViewController()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        }
    }
}
