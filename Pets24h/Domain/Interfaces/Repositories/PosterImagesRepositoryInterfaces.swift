//
//  PosterImagesRepositoryInterfaces.swift
//  Pets24h
//
//  Created by Vinh Huynh on 12/24/19.
//

import Foundation.NSData

protocol PosterImagesRepository {
    func image(with imagePath: String, width: Int, completion: @escaping (Result<Data, Error>) -> Void) -> Cancelable?
}
