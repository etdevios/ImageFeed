//
//  URLSession+DataTask.swift
//  ImageFeed
//
//  Created by Eduard Tokarev on 09.03.2023.
//

import Foundation

private enum NetworkError: Error {
    case urlRequestError(Error)
    case urlSessionError
    case httpStatusCode(Int)
}

extension URLSession {
    func objectTask<T: Decodable>(
        for request: URLRequest,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> URLSessionTask {
        let fulfillCompletionOnMainThread: (Result<T, Error>) -> Void = { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
        
        let task = dataTask(with: request, completionHandler: { data, response, error in
            guard
                let data = data,
                let response = response,
                let statusCode = (response as? HTTPURLResponse)?.statusCode else {
                if let error = error {
                    fulfillCompletionOnMainThread(.failure(NetworkError.urlRequestError(error)))
                } else {
                    fulfillCompletionOnMainThread(.failure(NetworkError.urlSessionError))
                }
                return
            }
            
            if 200 ..< 300 ~= statusCode {
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    decoder.dateDecodingStrategy = .iso8601
                    let result = try decoder.decode(T.self, from: data)
                    fulfillCompletionOnMainThread(.success(result))
                } catch {
                    fulfillCompletionOnMainThread(.failure(NetworkError.urlRequestError(error)))
                }
            } else {
                fulfillCompletionOnMainThread(.failure(NetworkError.httpStatusCode(statusCode)))
            }
        })
        return task
    }
}
