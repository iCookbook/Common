//
//  MockNetworkManager.swift
//  Search-Unit-Tests
//
//  Created by Егор Бадмаев on 24.12.2022.
//

import Networking
import Models

class StubNetworkManager: NetworkManagerProtocol {
    
    var isSuccess: Bool!
    
    func perform<Model>(request: NetworkRequest, completion: @escaping (Result<Model, NetworkManagerError>) -> Void) where Model : Decodable, Model : Encodable {
        if isSuccess {
            let result = Response(from: nil, to: nil, count: nil, links: nil, hits: nil)
            completion(.success(result as! Model))
        } else {
            completion(.failure(.decodingError))
        }
    }
    
    func obtainData(request: NetworkRequest, completion: @escaping (Result<Data, NetworkManagerError>) -> Void) {
        if isSuccess {
            let data = Data()
            completion(.success(data))
        } else {
            completion(.failure(.decodingError))
        }
    }
}
