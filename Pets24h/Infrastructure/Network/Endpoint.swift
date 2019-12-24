//
//  Endpoint.swift
//  Pets24h
//
//  Created by Vinh Huynh on 12/19/19.
//

import Foundation

enum HTTPMethodType: String {
    case get        = "GET"
    case head       = "HEAD"
    case post       = "POST"
    case put        = "PUT"
    case delete     = "DELETE"
}

enum BodyEncoding {
    case jsonSerializationData
    case stringEncodingAscii
}

enum RequestGenerationError: Error {
    case components
}

protocol Requestable {
    var path: String { get }
    var isFullPath: Bool { get }
    var method: HTTPMethodType { get }
    var bodyEncoding: BodyEncoding { get }
    var bodyParameters: [String: Any] { get }
    var queryParameters: [String: Any] { get }
    var headerParameters: [String: String] { get }
    
    func urlRequest(with config: NetworkConfigurable) throws -> URLRequest
}

extension Requestable {
    func urlRequest(with config: NetworkConfigurable) throws -> URLRequest {
        let url = try self.url(with: config)
        var urlRequest = URLRequest(url: url)
        var allHeaders: [String: String] = config.headers
        headerParameters.forEach({ allHeaders.updateValue($1, forKey: $0) })
        
        if !bodyParameters.isEmpty {
            urlRequest.httpBody = encodeBody(bodyParameter: bodyParameters, bodyEncoding: bodyEncoding)
        }
        
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = allHeaders
        return urlRequest
    }
    
    func url(with config: NetworkConfigurable) throws -> URL {
        
        let baseURL = config.baseURL.absoluteString.last != "/" ? config.baseURL.absoluteString.appending("/") : config.baseURL.absoluteString
        let endpoint = isFullPath ? path : baseURL.appending(path)
        
        guard var urlComponents = URLComponents(string: endpoint) else { throw RequestGenerationError.components }
        var urlQueryItems: [URLQueryItem] = []
        
        queryParameters.forEach({ urlQueryItems.append(URLQueryItem(name: $0, value: "\($1)")) })
        config.queryParameters.forEach({ urlQueryItems.append(URLQueryItem(name: $0, value: $1)) })
        
        urlComponents.queryItems = !urlQueryItems.isEmpty ? urlQueryItems : nil
        guard let url = urlComponents.url else { throw RequestGenerationError.components }
        
        return url
    }
    
    private func encodeBody(bodyParameter: [String: Any], bodyEncoding: BodyEncoding) -> Data? {
        switch bodyEncoding {
        case .jsonSerializationData:
            return try? JSONSerialization.data(withJSONObject: bodyParameters, options: .prettyPrinted)
            
        case .stringEncodingAscii:
            return bodyParameters.queryString.data(using: .ascii, allowLossyConversion: true)
        }
    }
}

class Endpoint: Requestable {
    var path: String
    var isFullPath: Bool
    var method: HTTPMethodType
    var bodyEncoding: BodyEncoding
    var bodyParameters: [String: Any]
    var queryParameters: [String: Any]
    var headerParameters: [String: String]
    
    init(path: String,
         isFullPath: Bool = false,
         method: HTTPMethodType = .get,
         bodyParameters: [String: Any] = [:],
         queryParameters: [String: Any] = [:],
         headerParameters: [String: String] = [:],
         bodyEncoding: BodyEncoding = .jsonSerializationData) {
        
        self.path = path
        self.method = method
        self.isFullPath = isFullPath
        self.bodyEncoding = bodyEncoding
        self.bodyParameters = bodyParameters
        self.queryParameters = queryParameters
        self.headerParameters = headerParameters
    }
}

final class DataEndpoint<T: Decodable>: Endpoint {}

private extension Dictionary {
    var queryString: String {
        return self.map({ "\($0.key)=\($0.value)" })
            .joined(separator: "&")
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    }
}
