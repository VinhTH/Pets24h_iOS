//
//  NetworkService.swift
//  Pets24h
//
//  Created by Vinh Huynh on 12/19/19.
//

import Foundation

protocol NetworkService {
    func request(endpoint: Requestable, completion: @escaping (Result<Data?, NetworkError>) -> Void) -> Cancelable?
}

final class DefaultNetworkService: NetworkService {
    
    private let session: NetworkSession
    private let config: NetworkConfigurable
    private let logger: NetworkErrorLogger
    
    init(session: NetworkSession,
         config: NetworkConfigurable,
         logger: NetworkErrorLogger = DefaultNetworkErrorLogger()) {
        
        self.session = session
        self.config = config
        self.logger = logger
    }
    
    func request(endpoint: Requestable, completion: @escaping (Result<Data?, NetworkError>) -> Void) -> Cancelable? {
        do {
            let urlRequest = try endpoint.urlRequest(with: config)
            return request(request: urlRequest, completion: completion)
        } catch {
            completion(.failure(NetworkError.urlGeneration))
            return nil
        }
    }
    
    func request(request: URLRequest, completion: @escaping (Result<Data?, NetworkError>) -> Void) -> Cancelable {
        let sessionDataTask = session.loadData(from: request) { [weak self] (data, response, requestError) in
            if let response = response as? HTTPURLResponse, (400..<600).contains(response.statusCode) {
                self?.logger.log(statusCode: response.statusCode)
                completion(.failure(.errorStatusCode(statusCode: response.statusCode)))
                return
            }
            
            if let requestError = requestError {
                let error: NetworkError
                if requestError._code == NSURLErrorNotConnectedToInternet {
                    error = .notConnected
                } else if requestError._code == NSURLErrorCancelled {
                    error = .cancelled
                } else {
                    error = .requestError(requestError)
                }
                self?.logger.log(error: requestError)
                completion(.failure(error))
            } else {
                self?.logger.log(responseData: data)
                completion(.success(data))
            }
        }
        
        logger.log(request: request)
        
        return sessionDataTask
    }
}

// MARK: Session
protocol NetworkSession {
    func loadData(from request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> Cancelable
}

extension URLSession: NetworkSession {
    func loadData(from request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> Cancelable {
        let task = dataTask(with: request) { (data, response, error) in
            completionHandler(data, response, error)
        }
        task.resume()
        return task
    }
}

extension URLSessionTask: Cancelable { }

// MARK: Network Error
enum NetworkError: Error {
    case errorStatusCode(statusCode: Int)
    case notConnected
    case cancelled
    case urlGeneration
    case requestError(Error?)
}

extension NetworkError {
    var isNotFoundError: Bool { return hasStatusCode(404) }
    
    func hasStatusCode(_ codeError: Int) -> Bool {
        switch self {
        case .errorStatusCode(let code):
            return code == codeError
        default:
            return false
        }
    }
}

// MARK: Logger
protocol NetworkErrorLogger {
    func log(request: URLRequest)
    func log(responseData data: Data?)
    func log(error: Error)
    func log(statusCode: Int)
}

final public class DefaultNetworkErrorLogger: NetworkErrorLogger {
    public init() { }
    
    public func log(request: URLRequest) {
        #if DEBUG
        print("----------")
        print("request: \(request.url!)")
        print("headers: \(request.allHTTPHeaderFields!)")
        print("method: \(request.httpMethod!)")
        if let httpBody = request.httpBody, let result = ((try? JSONSerialization.jsonObject(with: httpBody, options: []) as? [String: AnyObject]) as [String: AnyObject]??) {
            print("body: \(String(describing: result))")
        }
        if let httpBody = request.httpBody, let resultString = String(data: httpBody, encoding: .utf8) {
            print("body: \(String(describing: resultString))")
        }
        #endif
    }
    
    public func log(responseData data: Data?) {
        #if DEBUG
        guard let data = data else { return }
        if let dataDict =  try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            print("----------")
            print("responseData: \(String(describing: dataDict))")
        }
        #endif
    }
    
    public func log(error: Error) {
        #if DEBUG
        print("----------")
        print("error: \(error)")
        #endif
    }
    
    public func log(statusCode: Int) {
        #if DEBUG
        print("----------")
        print("status code: \(statusCode)")
        #endif
    }
}
