//
//  LoginTests.swift
//  NetworkingTests
//
//  Created by Gustavo Amaral on 19/04/20.
//  Copyright © 2020 Gustavo Almeida Amaral. All rights reserved.
//

import XCTest
import Combine
@testable import Networking

class LoginTests: XCTestCase {
    
    func testSuccessfulLogin() {
        let testsBundle = Bundle(identifier: "com.almeidaws.BankStatement.NetworkingTests")!
        let responseURL = testsBundle.url(forResource: "login_success", withExtension: "txt")!
        let responseData = try! Data(contentsOf: responseURL)
        let requestURL = URL(string: "https://example.com")!
        R.mockedResponse = Future { $0(.success(.init(data: responseData, status: .ok, request: .init(url: requestURL)))) }
        
        let expectedResponse = try! JSONDecoder().decode(Login.Response.self, from: responseData)
        let expectation = self.expectation(description: "Wait response")
        _ = login(.init(user: "123", password: "123"), testsBundle)
            .sink(receiveCompletion: { completion in }, receiveValue: { response in
                XCTAssert(response == expectedResponse, "The received response isn't equal to the expected.")
                expectation.fulfill()
            })
        
        self.wait(for: [expectation], timeout: 0.1)
    }

    func testFailedLogin() {
        let testsBundle = Bundle(identifier: "com.almeidaws.BankStatement.NetworkingTests")!
        let responseURL = testsBundle.url(forResource: "login_failure", withExtension: "txt")!
        let responseData = try! Data(contentsOf: responseURL)
        let requestURL = URL(string: "https://example.com")!
        R.mockedResponse = Future { $0(.success(.init(data: responseData, status: .ok, request: .init(url: requestURL)))) }
        
        let expectedResponse = try! JSONDecoder().decode(Login.Response.self, from: responseData)
        let expectation = self.expectation(description: "Wait response")
        _ = login(.init(user: "123", password: "123"), testsBundle)
            .sink(receiveCompletion: { completion in }, receiveValue: { response in
                XCTAssert(response == expectedResponse, "The received response isn't equal to the expected.")
                expectation.fulfill()
            })
        
        self.wait(for: [expectation], timeout: 0.1)
    }
}
