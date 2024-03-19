//
//  MockNetworkController.swift
//  HandshakeTests
//
//  Created by Yariv on 3/19/24.
//

import Foundation
@testable import Handshake

class MockNetworkController: NetworkController {
    let json: String

    init(json: String) {
        self.json = json
    }

    func get<DataType>(urlString: String) async throws -> DataType where DataType : Decodable {
        do {
            let data = try getJSON(from: json)
            let result = try JSONDecoder().decode(DataType.self, from: data)
            return result
        } catch {
            throw NetworkError.JSONError(error)
        }
    }
    
    func get<DataType>(urlString: String, completion: @escaping (Result<DataType, NetworkError>) -> Void) where DataType : Decodable {
        let decoder = JSONDecoder()

        do {
            let data = try getJSON(from: json)
            let result = try decoder.decode(DataType.self, from: data)
            completion(.success(result))
        } catch {
            completion(.failure(.JSONError(error)))
        }
    }
}

// get JSON from file
extension MockNetworkController {
    enum DecodeError: Error {
        case invalidFile(String)
        case fileNotFound(String)
    }
    
    func getJSON(from fileName: String) throws -> Data {
        let fileComponents = fileName.split(separator: ".")
        guard fileComponents.count == 2,
              let resource = fileComponents.first,
              let `extension` = fileComponents.last
        else {
            throw DecodeError.invalidFile(fileName)
        }
        
        guard let url = Bundle.main.url(forResource: String(resource), withExtension: String(`extension`)) else {
            throw DecodeError.fileNotFound(fileName)
        }
        return try Data(contentsOf: url)
    }
}
