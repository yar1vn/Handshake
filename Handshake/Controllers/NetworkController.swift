//
//  NetworkController.swift
//  Handshake
//
//  Created by Yariv on 3/19/24.
//

import Foundation

protocol NetworkController {
    func get<DataType: Decodable>(urlString: String, completion: @escaping (Result<DataType, NetworkError>) -> Void)
}

enum NetworkError: Error {
    case invalidURL(String)
    case dataError(Error)
    case HTTPError
    case JSONError(Error)
}

final class NetworkControllerImpl: NetworkController {
    func get<DataType>(urlString: String, completion: @escaping (Result<DataType, NetworkError>) -> Void)
    where DataType : Decodable {
        get(urlString: urlString) { result in
            do {
                let data = try result.get()
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase

                let parsedData = try decoder.decode(DataType.self, from: data)
                completion(.success(parsedData))
            } catch let error as NetworkError {
                completion(.failure(error))
            } catch {
                completion(.failure(NetworkError.JSONError(error)))
            }
        }
    }

    private func get(urlString: String, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL(urlString)))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                // error is guaranteed to be non-nil in documentation when data is nil
                completion(.failure(.dataError(error!)))
                return
            }

            // validate http response code
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(.failure(.HTTPError))
                return
            }

            completion(.success(data))
        }
        .resume()
    }
}
