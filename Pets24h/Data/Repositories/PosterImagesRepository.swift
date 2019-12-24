//
//  PosterImagesRepository.swift
//  Pets24h
//
//  Created by Vinh Huynh on 12/24/19.
//

import Foundation.NSData

final class DefaultPosterImagesRepository: PosterImagesRepository {
    private let dataTransferService: DataTransfer
    private let imageNotFoundData: Data?
    
    init(dataTransferService: DataTransfer, imageNotFoundData: Data?) {
        self.dataTransferService = dataTransferService
        self.imageNotFoundData = imageNotFoundData
    }
    
    func image(with imagePath: String, width: Int, completion: @escaping (Result<Data, Error>) -> Void) -> Cancelable? {
        let endpoint = APIEndpoints.moviePoster(path: imagePath, width: width)
        return dataTransferService.request(with: endpoint) { [weak self] result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                guard case DataTransferError.networkFailure(let networkError) = error,
                    networkError.isNotFoundError,
                    let imageNotFoundData = self?.imageNotFoundData else {
                    
                        completion(.failure(error))
                    return
                }
                
                completion(.success(imageNotFoundData))
            }
        }
    }
}
