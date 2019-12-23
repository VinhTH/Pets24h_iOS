//
//  NetworkConfigMock.swift
//  Pets24hTests
//
//  Created by Vinh Huynh on 12/20/19.
//

import Foundation

struct NetworkConfigMock: NetworkConfigurable {
    let baseURL: URL = URL(string: "https://mock.test.com")!
    let headers: [String : String] = [:]
    let queryParameters: [String : String] = [:]
    
}
