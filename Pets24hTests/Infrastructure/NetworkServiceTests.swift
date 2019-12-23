//
//  NetworkServiceTests.swift
//  Pets24hTests
//
//  Created by Vinh Huynh on 12/20/19.
//  Copyright © 2019 Vinh Huynh. All rights reserved.
//

import XCTest

class NetworkServiceTests: XCTestCase {
    
    private struct EndpointMock: Requestable {
        var path: String
        var method: HTTPMethodType
        var isFullPath: Bool = false
        var bodyParameters: [String : Any] = [:]
        var queryParameters: [String : Any] = [:]
        var headerParameters: [String : String] = [:]
        var bodyEncoding: BodyEncoding = .stringEncodingAscii
        
        init(path: String, method: HTTPMethodType) {
            self.path = path
            self.method = method
        }
    }
    
    private enum NetworkErrorMock: Error {
        case someError
    }
    
    private class NetworkErrorLoggerMock: NetworkErrorLogger {
        var logErrors: [Error] = []
        func log(error: Error) { logErrors.append(error) }
        func log(statusCode: Int) { }
        func log(request: URLRequest) { }
        func log(responseData data: Data?) { }
    }
    
    func test_whenMockDataPassed_shouldReturnProperResponse() {
        /// Given
        let networkConfigMock = NetworkConfigMock()
        let expectation = self.expectation(description: "Should return correct data")
        
        let expectedResponseData = "Response Data".data(using: .ascii, allowLossyConversion: true)
        let networkSessionMock = NetworkSessionMock(data: expectedResponseData, response: nil, error: nil)
        
        let sut = DefaultNetworkService(session: networkSessionMock, config: networkConfigMock)
        
        /// When
        _ = sut.request(endpoint: EndpointMock(path: "http://mock.test.com", method: .get)) { result in
            guard let responseData = try? result.get() else {
                XCTFail("Should return correct data")
                return
            }
            XCTAssertEqual(responseData, expectedResponseData)
            expectation.fulfill()
        }
        /// Then
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_whenErrorWithNSURLErrorCancelledReturned_shouldReturnNetworkErrorCancelled() {
        /// Given
        let cancelledError = NSError(domain: "network", code: NSURLErrorCancelled, userInfo: nil)
        let response = HTTPURLResponse(url: URL(string: "test_url")!,
                                       statusCode: 200,
                                       httpVersion: "1.1",
                                       headerFields: [:])
        let networkSessionMock = NetworkSessionMock(data: nil,
                                                    response: response,
                                                    error: cancelledError)
        
        let expectation = self.expectation(description: "Shoud return NetworkError.cancelled")
        
        let sut = DefaultNetworkService(session: networkSessionMock, config: NetworkConfigMock())
        
        /// When
        _ = sut.request(endpoint: EndpointMock(path: "http://mock.test.com", method: .get)) { result in
            do {
                _ = try result.get()
                XCTFail("Should not happen")
            } catch {
                guard case NetworkError.cancelled = error else {
                    XCTFail("Should return NetworkError.cancelled")
                    return
                }
                
                expectation.fulfill()
            }
        }
        
        /// Then
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_whenMalformedUrlPassed_shouldReturnUrlGenerationError() {
        /// Given
        let expectation = self.expectation(description: "Should return url generation error")
        let sut = DefaultNetworkService(session: NetworkSessionMock(), config: NetworkConfigMock())
        
        /// When
        _ = sut.request(endpoint: EndpointMock(path: "$%^$^$", method: .get)) { result in
            switch result {
            case .success:
                XCTFail("Should not happen")
            case .failure(let error):
                guard case NetworkError.urlGeneration = error else {
                    XCTFail("Shoudl return NetworkError.urlGeneration")
                    return
                }
                
                expectation.fulfill()
            }
        }
        
        /// Then
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_whenStatusCodeEqualOrAbove400_shouldReturnHasStatusCodeError() {
        /// Given
        let expectation = self.expectation(description: "Should return hasStatusCode error")
        
        let response = HTTPURLResponse(
            url: URL(string: "test_url")!,
            statusCode: 500,
            httpVersion: "1.1",
            headerFields: [:]
        )
        
        let networkSessionMock = NetworkSessionMock(data: nil, response: response, error: NetworkErrorMock.someError)
        let sut = DefaultNetworkService(session: networkSessionMock, config: NetworkConfigMock())
        
        /// When
        _ = sut.request(endpoint: EndpointMock(path: "http://mock.test.com", method: .get)) { result in
            switch result {
            case .success:
                XCTFail("Should not happen")
            case .failure(let error):
                guard case NetworkError.errorStatusCode(let statusCode) = error else {
                    XCTFail("Should return hasStatusCode Error")
                    return
                }
                
                XCTAssertEqual(statusCode, 500)
                expectation.fulfill()
            }
        }
        
        /// Then
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_whenErrorWithNSURLErrorNotConnectedToInternetReturned_shouldReturnNotConnectedError() {
        /// Given
        let expectation = self.expectation(description: "Should return not connected error")
        let response = HTTPURLResponse(url: URL(string: "tset_url")!, statusCode: 200, httpVersion: "1.1", headerFields: nil)
        let error = NSError(domain: "network", code: NSURLErrorNotConnectedToInternet, userInfo: nil)
        let networkSessionMock = NetworkSessionMock(data: nil, response: response, error: error)
        let sut = DefaultNetworkService(session: networkSessionMock, config: NetworkConfigMock())
        
        /// When
        _ = sut.request(endpoint: EndpointMock(path: "http://mock.test.com", method: .get)) { result in
            switch result {
            case .success:
                XCTFail("Should not happen")
            case .failure(let error):
                guard case NetworkError.notConnected = error else {
                    XCTFail("Should return not connected error")
                    return
                }
                
                expectation.fulfill()
            }
        }
        
        /// Then
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_whenHasStatusCodeUsedWithWrongError_shouldReturnFalse() {
        /// Given
        let sut = NetworkError.notConnected
        /// Then
        XCTAssertFalse(sut.hasStatusCode(200))
    }
    
    func test_whenHasStatusCodeUsed_shouldReturnCorrectStatusCode() {
        /// Given
        let sut = NetworkError.errorStatusCode(statusCode: 400)
        /// Then
        XCTAssertTrue(sut.hasStatusCode(400))
        XCTAssertFalse(sut.hasStatusCode(399))
        XCTAssertFalse(sut.hasStatusCode(401))
    }
    
    func test_whenErrorWithNSURLErrorNotConnectedToInternetReturned_shouldLogThisError() {
        /// Given
        let expectation = self.expectation(description: "Should log not connected error")
        let response = HTTPURLResponse(url: URL(string: "test_url")!, statusCode: 200, httpVersion: "1.1", headerFields: nil)
        let error = NSError(domain: "network", code: NSURLErrorNotConnectedToInternet, userInfo: nil)
        let networkSessionMock = NetworkSessionMock(data: nil, response: response, error: error)
        let networkErrorLoggerMock = NetworkErrorLoggerMock()
        let sut = DefaultNetworkService(session: networkSessionMock, config: NetworkConfigMock(), logger: networkErrorLoggerMock)
        
        /// When
        _ = sut.request(endpoint: EndpointMock(path: "http://test.mock.com", method: .get)) { result in
            switch result {
            case .success:
                XCTFail("Shoudl not happen")
            case .failure(let error):
                guard case NetworkError.notConnected = error else {
                    XCTFail("Should return not connected")
                    return
                }
                
                expectation.fulfill()
            }
        }
        
        /// Then
        wait(for: [expectation], timeout: 0.1)
        XCTAssertTrue(networkErrorLoggerMock.logErrors.contains(where: { $0._code == NSURLErrorNotConnectedToInternet }))
    }
}
