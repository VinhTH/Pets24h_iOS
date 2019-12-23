//
//  DataTransferTests.swift
//  Pets24hTests
//
//  Created by Vinh Huynh on 12/23/19.
//

import XCTest

class DataTransferTests: XCTestCase {
    private struct MockModel: Decodable {
        let name: String
    }
    
    func test_whenNoDataReceived_shouldReturnNoResponseError() {
        /// Given
        let expectation = self.expectation(description: "Shoudl return no response error")
        let response = HTTPURLResponse(url: URL(string: "test_url")!, statusCode: 200, httpVersion: "1.1", headerFields: nil)
        let networkSessionMock = NetworkSessionMock(data: nil, response: response, error: nil)
        let networkService = DefaultNetworkService(session: networkSessionMock, config: NetworkConfigMock())
        let sut = DefaultDataTransferService(networkService: networkService)
        /// When
        _ = sut.request(width: DataEndpoint<MockModel>(path: "http://mock.endpoint.com")) { result in
            switch result {
            case .success:
                XCTFail("Should not happen")
            case .failure(let error):
                guard case DataTransferError.noResponse = error else {
                    XCTFail("Should return no response error")
                    return
                }
                
                expectation.fulfill()
            }
        }
        /// Then
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_whenBadRequestReceived_shouldReturnNetworkError() {
        /// Given
        let expactation = self.expectation(description: "Should return network error")
        let response = HTTPURLResponse(url: URL(string: "test_url")!, statusCode: 200, httpVersion: "1.1", headerFields: nil)
        let error = NSError(domain: "network", code: NSURLErrorCancelled, userInfo: nil)
        let networkSessionMock = NetworkSessionMock(data: nil, response: response, error: error)
        let networkService = DefaultNetworkService(session: networkSessionMock, config: NetworkConfigMock())
        let sut = DefaultDataTransferService(networkService: networkService)
        /// When
        _ = sut.request(width: DataEndpoint<MockModel>(path: "http://mock.endpoint.com")) { result in
            switch result {
            case .success:
                XCTFail("Should not happen")
            case .failure(let error):
                guard case DataTransferError.networkFailure(NetworkError.cancelled) = error else {
                    XCTFail("Should return network error")
                    return
                }
                
                expactation.fulfill()
            }
        }
        /// Then
        wait(for: [expactation], timeout: 0.1)
    }
    
    func test_whenInvalidResponseReceived_shouldNotDecodeObject() {
        /// Given
        let expectation = self.expectation(description: "Should not decode object")
        let responseData = #"{name: Vinh HT}"#.data(using: .utf8)
        let networkSessionMock = NetworkSessionMock(data: responseData, response: nil, error: nil)
        let networkService = DefaultNetworkService(session: networkSessionMock, config: NetworkConfigMock())
        let sut = DefaultDataTransferService(networkService: networkService)
        /// When
        _ = sut.request(width: DataEndpoint<MockModel>(path: "http://mock.endpoint.com")) { result in
            switch result {
            case .success:
                XCTFail("Should not happen")
            case .failure(let error):
                guard case DataTransferError.parsingJSON = error else {
                    XCTFail("Should return data transfer prasing JSON error")
                    return
                }
                
                expectation.fulfill()
            }
        }
        /// Then
        wait(for: [expectation], timeout: 0.1)
    }
    
    func test_whenValidResponseReceived_shouldDecodeResponseToDecodableObject() {
        /// Given
        let expectation = self.expectation(description: "Should decode response to decodable object")
        let responseData = #"{"name": "Vinh HT"}"#.data(using: .utf8)
        let networkSessionMock = NetworkSessionMock(data: responseData, response: nil, error: nil)
        let networkService = DefaultNetworkService(session: networkSessionMock, config: NetworkConfigMock())
        let sut = DefaultDataTransferService(networkService: networkService)
        /// When
        _ = sut.request(width: DataEndpoint<MockModel>(path: "http://mock.endpoint.com")) { result in
            switch result {
            case .success(let object):
                XCTAssertEqual(object.name, "Vinh HT")
                expectation.fulfill()
            case .failure:
                XCTFail("Should not happen")
            }
        }
        /// Then
        wait(for: [expectation], timeout: 0.1)
    }
}
