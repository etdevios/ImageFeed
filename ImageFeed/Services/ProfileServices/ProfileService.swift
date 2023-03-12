//
//  ProfileService.swift
//  ImageFeed
//
//  Created by Eduard Tokarev on 05.03.2023.
//

import Foundation

final class ProfileService {
    private var task: URLSessionTask?
    private var lastToken: String?
    
    static let shared = ProfileService()
    private init() {}
    private(set) var profile: Profile?
    
    func fetchProfile(_ token: String, completion: @escaping (Result<Profile, Error>) -> Void) {
        assert(Thread.isMainThread)
        if lastToken == token { return }
        task?.cancel()
        lastToken = token
        
        let request = makeRequest(token)
        
        let session = URLSession.shared
        let task = session.objectTask(for: request) { (result: Result<ProfileResult, Error>) in
            switch result {
            case .success(let responseBody):
                self.profile = Profile(from: responseBody)
                guard let profile = self.profile else {return}
                completion(.success(profile))
                self.profile = profile
                self.task = nil
            case .failure(let error):
                completion(.failure(error))
                self.lastToken = nil
                
            }
        }
        self.task = task
        task.resume()
    }
    
    private func makeRequest(_ token: String) -> URLRequest {
        var urlComponents = URLComponents(string: K.API.defaultBaseURL)
        urlComponents?.path = "/me"
        guard let url = urlComponents?.url else { fatalError("Failed to create URL") }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
