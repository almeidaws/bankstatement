//
//  RequisitionsTests.swift
//  RequisitionsTests
//
//  Created by Gustavo Amaral on 17/04/20.
//  Copyright © 2020 Gustavo Almeida Amaral. All rights reserved.
//

import XCTest
import Combine
@testable import Networking

class RequisitionsTests: XCTestCase {

    func testSuccessfulResponseEqualToSent() {
        let url = URL(string: "https://example.com")!
        let data = "abc".data(using: .utf8)
        let request = URLRequest(url: url)
        let sentResponse = Requisitions.RequestResponse(data: data, status: .ok, request: request)
        Requisitions.mockedResponse = Future { $0(.success(sentResponse)) }
        
        let expectation = self.expectation(description: "Wait response")
        _ = Requisitions.request(at: url, method: .get)
            .sink(receiveCompletion: { _ in }) { receivedResponse in
                XCTAssert(receivedResponse == sentResponse, "The mocked response sent to the request isn't the same as the received.")
                expectation.fulfill()
        }
        
        self.wait(for: [expectation], timeout: 0.1)
    }
    
    func testFailedResponseEqualToSent() {
        Requisitions.mockedResponse = Future { $0(.failure(.notHTTPURLResponse)) }
        
        let expectation = self.expectation(description: "Wait response")
        _ = Requisitions.request(at: URL(string: "https://example.com")!, method: .get)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    XCTAssert(error == Requisitions.RequestError.notHTTPURLResponse, "The mocked sent error isn't the same as the received.")
                    expectation.fulfill()
                default: break
                }
            }) { _ in }
        
        self.wait(for: [expectation], timeout: 0.1)
    }
    
    func testSuccessfulGetRequest() {
        let url = URL(string: "https://example.com")!
        let data = "abc".data(using: .utf8)
        let request = URLRequest(url: url)
        let sentResponse = Requisitions.RequestResponse(data: data, status: .ok, request: request)
        Requisitions.mockedResponse = Future { $0(.success(sentResponse)) }
        
        let expectation = self.expectation(description: "Wait response")
        _ = Requisitions.get(from: url)
            .sink(receiveCompletion: { _ in }) { receivedResponse in
                XCTAssert(receivedResponse == sentResponse, "The mocked response sent to the request isn't the same as the received.")
                expectation.fulfill()
        }
        
        self.wait(for: [expectation], timeout: 0.1)
    }
}
