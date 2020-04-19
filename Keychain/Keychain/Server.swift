//
//  Server.swift
//  Keychain
//
//  Created by Gustavo Amaral on 19/04/20.
//  Copyright © 2020 Gustavo Almeida Amaral. All rights reserved.
//

import Foundation

fileprivate let KEYCHAIN_SERVER = "KEYCHAIN_SERVER"
enum Server { }

extension Server {
    static func address(_ bundle: Bundle = .main) -> String {
        guard let basePath = bundle.object(forInfoDictionaryKey: KEYCHAIN_SERVER) else {
            fatalError("There's no value for key '\(KEYCHAIN_SERVER)' in Info.plist file.")
        }
        guard let basePathStr = basePath as? String else {
            fatalError("The value for key '\(basePath)' isn't a string.")
        }
        return basePathStr
    }
}
