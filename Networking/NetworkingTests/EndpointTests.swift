//
//  EndpointTests.swift
//  NetworkingTests
//
//  Created by Gustavo Amaral on 19/04/20.
//  Copyright © 2020 Gustavo Almeida Amaral. All rights reserved.
//

import XCTest
@testable import Networking

class EndpointTests: XCTestCase {
    
    func testLoginEndpoint() {
        let testsBundle = Bundle(identifier: "com.almeidaws.BankStatement.NetworkingTests")!
        XCTAssert(Endpoint.login(testsBundle) == URL(string: "https://example.com/api/login")!, "Built login endpoint isn't the expected")
    }

}
