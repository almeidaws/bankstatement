//
//  Requisitions.swift
//  Networking
//
//  Created by Gustavo Amaral on 17/04/20.
//  Copyright © 2020 Gustavo Almeida Amaral. All rights reserved.
//

import Foundation
import Combine

enum Requisitions {
    
    static var mockedResponse: Future<RequestResponse, RequestError>?
    
    enum Method: String {
        case get
    }
    
    enum RequestError: Error, LocalizedError, CustomStringConvertible, Hashable {
        
        case unmapped(Error)
        case notHTTPURLResponse
        case unknownStatusCode(Int)
        
        var localizedDescription: String {
            switch self {
            case .unmapped(let error): return error.localizedDescription
            case .notHTTPURLResponse: return "The response received isn't of type HTTPURLResponse."
            case .unknownStatusCode(let status): return "Unknown status code \(status)"
            }
        }
        
        var description: String {
            return self.localizedDescription
        }
        
        static func == (lhs: Requisitions.RequestError, rhs: Requisitions.RequestError) -> Bool {
            return lhs.localizedDescription == rhs.localizedDescription
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(localizedDescription)
        }
    }
    
    struct RequestResponse: Hashable {
        let data: Data?
        let status: HTTPStatusCode
    }
}

extension Requisitions {
    static func request(at url: URL, method: Method, headers: [String : String] = [:], body: Data? = nil) -> Future<RequestResponse, RequestError> {
        
        if let mockedResponse = self.mockedResponse {
            return mockedResponse
        }
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        request.httpMethod = method.rawValue
        request.httpBody = body
        
        return Future { promise in
            let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    promise(.failure(.unmapped(error)))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else { promise(.failure(.notHTTPURLResponse)); return }
                guard let status = HTTPStatusCode(rawValue: httpResponse.statusCode) else { promise(.failure(.unknownStatusCode(httpResponse.statusCode))); return }
                return promise(.success(RequestResponse(data: data, status: status)))
            }
            
            dataTask.resume()
        }
    }
}
