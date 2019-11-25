//
//  AppDIContainer.swift
//  Pets24h
//
//  Created by Vinh Huynh on 11/20/19.
//  Copyright © 2019 Vinh Huynh. All rights reserved.
//

final class AppDIContainer {
    // MARK: DIContainer of scenes
    func makeHomeSceneDIContainer() -> HomeSceneDIContainer {
        return HomeSceneDIContainer()
    }
}
