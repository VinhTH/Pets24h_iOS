//
//  DataTransferService.swift
//  Pets24h
//
//  Created by Vinh Huynh on 12/18/19.
//

import Foundation

enum DataTransferError: Error {
    case noResponse
    case parsingJSON
    case networkFailure(NetworkError)
}

protocol DataTransfer {
    func request<T: Decodable>(width endpoint: DataEndpoint<T>, completion: @escaping (Result<T, Error>) -> Void) -> Cancelable?
    func request<T: Decodable>(width endpoint: DataEndpoint<T>, respondOnQueue: DispatchQueue, completion: @escaping (Result<T, Error>) -> Void) -> Cancelable?
}

final class DefaultDataTransferService: DataTransfer {
    
    private let networkService: NetworkService
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    func request<T: Decodable>(width endpoint: DataEndpoint<T>, completion: @escaping (Result<T, Error>) -> Void) -> Cancelable? {
        return request(width: endpoint, respondOnQueue: .main, completion: completion)
    }
    
    func request<T: Decodable>(width endpoint: DataEndpoint<T>, respondOnQueue: DispatchQueue, completion: @escaping (Result<T, Error>) -> Void) -> Cancelable? {
        
        return networkService.request(endpoint: endpoint) { result in
            switch result {
            case .success(let data):
                guard let data = data else {
                    respondOnQueue.async {
                        completion(.failure(DataTransferError.noResponse))
                    }
                    return
                }
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(T.self, from: data)
                    respondOnQueue.async {
                        completion(.success(result))
                    }
                } catch {
                    respondOnQueue.async {
                        completion(.failure(DataTransferError.parsingJSON))
                    }
                }
            case .failure(let error):
                respondOnQueue.async {
                    completion(.failure(DataTransferError.networkFailure(error)))
                }
            }
        }
    }
}
