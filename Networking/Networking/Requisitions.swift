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
        case queryParameters(URL, [String : Any])
        
        var localizedDescription: String {
            switch self {
            case .unmapped(let error): return error.localizedDescription
            case .notHTTPURLResponse: return "The response received isn't of type HTTPURLResponse."
            case .unknownStatusCode(let status): return "Unknown status code \(status)"
            case let .queryParameters(url, parameters): return "Unable to create query parameters \(parameters) for \(url)"
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
        let request: URLRequest
    }
}

extension Requisitions {
    static func request(at url: URL, method: Method, headers: [String : String] = [:], queryParameters: [String : Any] = [:], body: Data? = nil) -> Future<RequestResponse, RequestError> {
        
        if let mockedResponse = self.mockedResponse {
            return mockedResponse
        }
        
        return Future { promise in
            
            guard let request = createRequest(url: url, method: method, headers: headers, queryParameters: queryParameters, body: body) else {
                promise(.failure(.queryParameters(url, queryParameters)))
                return
            }
            
            let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    promise(.failure(.unmapped(error)))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else { promise(.failure(.notHTTPURLResponse)); return }
                guard let status = HTTPStatusCode(rawValue: httpResponse.statusCode) else { promise(.failure(.unknownStatusCode(httpResponse.statusCode))); return }
                return promise(.success(RequestResponse(data: data, status: status, request: request)))
            }
            
            dataTask.resume()
        }
    }
}

extension Requisitions {
    static func get(from url: URL, headers: [String : String] = [:], queryParameters: [String : Any] = [:]) -> Future<RequestResponse, RequestError> {
        return request(at: url, method: .get, headers: headers, queryParameters: queryParameters)
    }
}

fileprivate extension Requisitions {
    static func createRequest(url: URL, method: Method, headers: [String : String], queryParameters: [String : Any], body: Data?) -> URLRequest? {
        guard let urlWithQueryParamaters = url.with(queryParameters: queryParameters) else { return nil }
            
        var request = URLRequest(url: urlWithQueryParamaters)
        request.allHTTPHeaderFields = headers
        request.httpMethod = method.rawValue
        request.httpBody = body
        return request
    }
}
