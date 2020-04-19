//
//  Keychain.swift
//  Keychain
//
//  Created by Gustavo Amaral on 19/04/20.
//  Copyright © 2020 Gustavo Almeida Amaral. All rights reserved.
//

import Foundation
import Networking

enum Keychain { }

extension Keychain {
    static func store(_ credentials: Login.Credentials, _ bundle: Bundle = .main) throws {
        guard let password = credentials.password.data(using: .utf8) else { throw KeychainError.converstioToData }
        let query: [String : Any] = [kSecClass as String : kSecClassInternetPassword,
                                     kSecAttrAccount as String : credentials.user,
                                     kSecAttrServer as String : Server.address(bundle),
                                     kSecValueData as String : password]
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }
    }
    
    static func search(_ bundle: Bundle = .main) throws -> Login.Credentials {
        let query: [String : Any] = [kSecClass as String : kSecClassInternetPassword,
                                     kSecAttrServer as String : Server.address(bundle),
                                     kSecMatchLimit as String : kSecMatchLimitOne,
                                     kSecReturnAttributes as String : true,
                                     kSecReturnData as String : true]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status != errSecItemNotFound else { throw KeychainError.noPassword }
        guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }
        guard let existingItem = item as? [String : Any],
            let passwordData = existingItem[kSecValueData as String] as? Data,
            let password = String(data: passwordData, encoding: .utf8),
            let account = existingItem[kSecAttrAccount as String] as? String
        else {
            throw KeychainError.unexpectedPasswordData
        }
        
        return .init(user: account, password: password)
    }
    
    static func delete(_ bundle: Bundle = .main) throws {
        let query: [String : Any] = [kSecClass as String : kSecClassInternetPassword,
                                     kSecAttrServer as String: Server.address(bundle)]
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else { throw KeychainError.unhandledError(status: status) }
    }
}
