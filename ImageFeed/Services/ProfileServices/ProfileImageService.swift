//
//  ProfileImageService.swift
//  ImageFeed
//
//  Created by Eduard Tokarev on 05.03.2023.
//

import Foundation

final class ProfileImageServices {
    private var task: URLSessionTask?
    private var lastUsername: String?
    
    static let shared = ProfileImageServices()
    private(set) var avatarURL: String?
    
    static let didChangeNotification = Notification.Name(rawValue: "ProfileImageProviderDidChange")
    
    func fetchProfileImageURL(username: String, _ completion: @escaping (Result<String, Error>) -> Void) {
        assert(Thread.isMainThread)
        if lastUsername == username { return }
        task?.cancel()
        lastUsername = username
        
        let request = makeRequest(username)
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let session: URLSession = URLSession.shared
        let task = session.objectTask(for: request) { (result: Result<UserResult, Error>) in
            switch result {
            case .success(let responseBody):
                let profileImageURL = responseBody.profileImage.small
                self.avatarURL = profileImageURL
                completion(.success(profileImageURL))
                NotificationCenter.default
                    .post(
                        name: ProfileImageServices.didChangeNotification,
                        object: self,
                        userInfo: ["URL": profileImageURL])
                
                self.task = nil
            case .failure(let error):
                completion(.failure(error))
                self.lastUsername = nil
            }
        }
        self.task = task
        task.resume()
    }
    
    private func makeRequest(_ username: String) -> URLRequest {
        var urlComponents = URLComponents(string: K.API.defaultBaseURL)
        urlComponents?.path = "/users/\(username)"
        guard let url = urlComponents?.url else { fatalError("Failed to create URL") }
        var request = URLRequest(url: url)
        guard let token = OAuth2TokenStorage().token else { fatalError("Failed to create token") }
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
