//
//  KeychainError.swift
//  Keychain
//
//  Created by Gustavo Amaral on 19/04/20.
//  Copyright © 2020 Gustavo Almeida Amaral. All rights reserved.
//

import Foundation

enum KeychainError: Error, CustomStringConvertible, Hashable {
    case noPassword
    case unexpectedPasswordData
    case unhandledError(status: OSStatus)
    case converstioToData
    
    var localizedDescription: String {
        switch self {
        case .noPassword: return "There's no password."
        case .unexpectedPasswordData: return "Unexpected password data"
        case .unhandledError(status: let status): return "Unhandle error of status \(status)"
        case .converstioToData: return "Unable to convert to data"
        }
    }
    
    var description: String {
        return self.localizedDescription
    }
}
