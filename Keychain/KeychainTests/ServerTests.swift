//
//  ServerTests.swift
//  KeychainTests
//
//  Created by Gustavo Amaral on 19/04/20.
//  Copyright © 2020 Gustavo Almeida Amaral. All rights reserved.
//

import XCTest

class ServerTests: XCTestCase {

    func testServerName() {
        let testsBundle = Bundle(identifier: "com.almeidaws.BankStatement.KeychainTests")!
        XCTAssert(Server.address(testsBundle) == "https://example.com", "The server read from Info.plist isn't the expected.")
    }
}
