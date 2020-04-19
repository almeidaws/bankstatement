//
//  Statements.swift
//  Networking
//
//  Created by Gustavo Amaral on 19/04/20.
//  Copyright © 2020 Gustavo Almeida Amaral. All rights reserved.
//

import Foundation
import Combine

enum Statements {
    
    enum Response: Decodable, Hashable {
        case statements([Statement])
        case error(Error)
        
        enum CodingKeys: CodingKey {
            case statementList
            case error
        }
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            do {
                let statements = try container.decode([Statement].self, forKey: .statementList)
                self = .statements(statements)
            } catch {
                let error = try container.decode(Error.self, forKey: .error)
                self = .error(error)
            }
        }
    }
    
    struct Statement: Decodable, Hashable {
        let title: String
        let desc: String
        let date: String
        let value: Double
    }
    
    struct Error: Codable, Hashable {
        let code: Int
        let message: String
    }
}


func statements(userID: Int, _ bundle: Bundle = .main) -> AnyPublisher<Statements.Response, R.RequestError> {
    let headers = [ "Content-Type": "application/x-www-form-urlencoded" ]
    return R.get(from: .statements(userID: userID, bundle), headers: headers, decoder: JSONDecoder())
        .map { (decodedResponse: R.RequestDecodedResponse<Statements.Response>) -> Statements.Response in decodedResponse.data }
        .eraseToAnyPublisher()
}

