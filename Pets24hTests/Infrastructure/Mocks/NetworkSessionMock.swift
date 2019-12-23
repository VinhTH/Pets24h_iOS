//
//  NetworkSessionMock.swift
//  Pets24hTests
//
//  Created by Vinh Huynh on 12/20/19.
//

import Foundation

struct NetworkSessionMock: NetworkSession {
    let data: Data?
    let response: URLResponse?
    let error: Error?
    
    init(data: Data? = nil,
         response: URLResponse? = nil,
         error: Error? = nil) {
        
        self.data = data
        self.response = response
        self.error = error
    }
    
    func loadData(from request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> Cancelable {
        completionHandler(data, response, error)
        return URLSessionTask()
    }
}
