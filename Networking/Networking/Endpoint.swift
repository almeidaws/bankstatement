//
//  Endpoint.swift
//  Networking
//
//  Created by Gustavo Amaral on 18/04/20.
//  Copyright © 2020 Gustavo Almeida Amaral. All rights reserved.
//

import Foundation

fileprivate let BASE_URL_KEY = "BASE_URL_KEY"

enum Endpoint {
    fileprivate static func baseURL(_ bundle: Bundle = .main) -> URL {
        guard let basePath = bundle.object(forInfoDictionaryKey: BASE_URL_KEY) else {
            fatalError("There's no value for key '\(BASE_URL_KEY)' in Info.plist file.")
        }
        guard let basePathStr = basePath as? String else {
            fatalError("The value for key '\(basePath)' isn't a string.")
        }
        guard let baseURL = URL(string: basePathStr) else {
            fatalError("The base URL '\(basePathStr)' isn't really a valid URL.")
        }
        return baseURL
    }
}

extension Endpoint {
    static func login(_ bundle: Bundle = .main) -> URL {
        return baseURL(bundle)
            .appendingPathComponent("api")
            .appendingPathComponent("login")
    }
    
    static func statements(userID: Int, _ bundle: Bundle = .main) -> URL {
        return baseURL(bundle)
            .appendingPathComponent("api")
            .appendingPathComponent("statements")
            .appendingPathComponent("\(userID)")
    }
}

extension URL {
    static func login(_ bundle: Bundle = .main) -> URL {
        return Endpoint.login(bundle)
    }
    
    static func statements(userID: Int, _ bundle: Bundle = .main) -> URL {
        return Endpoint.statements(userID: userID, bundle)
    }
}
