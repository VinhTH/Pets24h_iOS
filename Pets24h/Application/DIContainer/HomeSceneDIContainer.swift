//
//  HomeSceneDIContainer.swift
//  Pets24h
//
//  Created by Vinh Huynh on 11/20/19.
//  Copyright © 2019 Vinh Huynh. All rights reserved.
//

import UIKit

final class HomeSceneDIContainer {
    func makeHomeViewController() -> UIViewController {
        return HomeViewController.create()
    }
}
