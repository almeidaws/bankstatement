//
//  KeychainTests.swift
//  KeychainTests
//
//  Created by Gustavo Amaral on 19/04/20.
//  Copyright © 2020 Gustavo Almeida Amaral. All rights reserved.
//

import XCTest
import Keychain
@testable import Networking

fileprivate let credentials = Login.Credentials(user: "123456", password: "98765432")

class KeychainTests: XCTestCase {
    
    override func setUp() {
        let testsBundle = Bundle(identifier: "com.almeidaws.BankStatement.KeychainTests")!
        try! Keychain.delete(testsBundle)
    }
    
    override class func tearDown() {
        let testsBundle = Bundle(identifier: "com.almeidaws.BankStatement.KeychainTests")!
        try! Keychain.delete(testsBundle)
    }
    
    func testStoringAndRetrieving() {
        let testsBundle = Bundle(identifier: "com.almeidaws.BankStatement.KeychainTests")!
        try! Keychain.store(credentials, testsBundle)
        let retrieved = try! Keychain.search(testsBundle)
        XCTAssert(retrieved == credentials, "The stored credentials isn't equal to the received one")
    }
    
    func testDeletingAndRetrieving() {
        let testsBundle = Bundle(identifier: "com.almeidaws.BankStatement.KeychainTests")!
        try! Keychain.store(credentials, testsBundle)
        try! Keychain.delete(testsBundle)
        do {
            _ = try Keychain.search(testsBundle)
        } catch let error where error is KeychainError {
            let keychainError = error as! KeychainError
            XCTAssert(keychainError == KeychainError.noPassword, "There's a password even after deletion.")
        } catch {
            // DOES NOTHING
        }
    }

}
