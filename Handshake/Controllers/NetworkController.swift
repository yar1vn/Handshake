//
//  NetworkController.swift
//  Handshake
//
//  Created by Yariv on 3/19/24.
//

import Foundation
import UIKit.UIImage

protocol NetworkController {
    func get<DataType>(urlString: String) async throws -> DataType where DataType : Decodable
    func getImage(url: URL) async throws -> UIImage
}

enum NetworkError: Error {
    case invalidURL(String)
    case dataError(Error)
    case HTTPError
    case JSONError(Error)
    case invalidImage(Data)
}

final class NetworkControllerImpl: NetworkController {
    // MARK: - async/await
    func get<DataType>(urlString: String) async throws -> DataType where DataType : Decodable {
        do {
            let data = try await get(urlString: urlString)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            let parsedData = try decoder.decode(DataType.self, from: data)
            return parsedData
        } catch let error as NetworkError {
            throw error
        } catch {
            throw NetworkError.JSONError(error)
        }
    }
    
    private func get(urlString: String) async throws -> Data {
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL(urlString)
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        // validate http response code
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.HTTPError
        }
        
        return data
    }
    
    func getImage(url: URL) async throws -> UIImage {
        let (data, _) = try await URLSession.shared.data(from: url)
        guard let image = UIImage(data: data) else {
            throw NetworkError.invalidImage(data)
        }
        return image
    }
}
