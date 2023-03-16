//
//  ImageListService.swift
//  ImageFeed
//
//  Created by Eduard Tokarev on 16.03.2023.
//

import Foundation

final class ImageListService {
    static let shared = ImageListService()
    private init() {}
    
    private (set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    
    static let didChangeNotification = Notification.Name(rawValue: "ImageListServiceDidChange")
    
    private var task: URLSessionTask?
    
    func fetchPhotosNextPage() {
        assert(Thread.isMainThread)
        if task != nil { return }
        task?.cancel()
        
        let nextPage = lastLoadedPage == nil ? 1 : lastLoadedPage! + 1
        
        let session = URLSession.shared
        let task = session.objectTask(for: makeRequest(lastLoadedPage)) { [weak self] (result: Result<[PhotoResult], Error>) in
            guard let self else { return }
            switch result {
            case .success(let photoResult):
                for photo in photoResult {
                    self.photos.append(Photo(from: photo))
                    
                    self.lastLoadedPage = 1
                }
                NotificationCenter.default
                    .post(
                        name: ImageListService.didChangeNotification,
                        object: self,
                        userInfo: ["photos": self.photos]
                    )
                self.task = nil
            case .failure(let error):
                print(error)
                self.task = nil
            }
        }
        self.task = task
        task.resume()
    }
    
    private func makeRequest(_ page: Int?) -> URLRequest {
        var urlComponents = URLComponents(string: K.API.defaultBaseURL)
        urlComponents?.path = "/photos"
        if let page {
            urlComponents?.queryItems = [
                .init(name: "page", value: "\(page)")
            ]
        }
        
        guard let url = urlComponents?.url else { fatalError("Failed to create URL") }
        print(url)
        var request = URLRequest(url: url)
        guard let token = OAuth2TokenStorage().token else { fatalError("Failed to create token") }
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        return request
    }
}
