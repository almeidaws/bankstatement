//
//  Login.swift
//  Networking
//
//  Created by Gustavo Amaral on 18/04/20.
//  Copyright © 2020 Gustavo Almeida Amaral. All rights reserved.
//

import Foundation
import Combine

public enum Login {
    
    enum Response: Decodable, Hashable {
        case userAccount(UserAccount)
        case error(Error)
        
        enum CodingKeys: CodingKey {
            case userAccount
            case error
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            do {
                let userAccount = try container.decode(UserAccount.self, forKey: .userAccount)
                self = .userAccount(userAccount)
            } catch {
                let error = try container.decode(Error.self, forKey: .error)
                self = .error(error)
            }
        }
        
        struct UserAccount: Codable, Hashable {
            let userId: Int
            let name: String
            let bankAccount: String
            let agency: String
            let balance: Double
        }
        
        struct Error: Codable, Hashable {
            let code: Int
            let message: String
        }
    }
    
    public struct Credentials: Codable, Hashable {
        public let user: String
        public let password: String
        
        public init(user: String, password: String) {
            self.user = user
            self.password = password
        }
        
        var asQueryParameters: String {
            "user=\(user)&password=\(password)"
        }
        
        func urlEncoded() -> String? {
            return self.asQueryParameters.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        }
    }
}

func login(_ credential: Login.Credentials, _ bundle: Bundle = .main) -> AnyPublisher<Login.Response, R.RequestError> {
    guard let urlEncoded = credential.urlEncoded() else { return Fail(outputType: Login.Response.self, failure: R.RequestError.urlEncoding(credential.asQueryParameters)).eraseToAnyPublisher() }
    guard let body = urlEncoded.data(using: .utf8) else { return Fail(outputType: Login.Response.self, failure: R.RequestError.conversionToData).eraseToAnyPublisher() }
    
    let headers = [ "Content-Type": "application/x-www-form-urlencoded" ]
    return R.post(to: .login(bundle), headers: headers, decoder: JSONDecoder(), body: body)
        .map { (decodedResponse: R.RequestDecodedResponse<Login.Response>) -> Login.Response in decodedResponse.data }
        .eraseToAnyPublisher()
}
