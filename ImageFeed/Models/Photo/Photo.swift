//
//  Photo.swift
//  ImageFeed
//
//  Created by Eduard Tokarev on 16.03.2023.
//

import Foundation

struct Photo {
    let id: String
    let size: CGSize
    let createdAt: Date?
    let welcomeDescription: String?
    let thumbImageURL: String
    let largeImageURL: String
    var isLiked: Bool
    
    init(from result: PhotoResult) {
        self.id = result.id
        self.size = CGSize(width: result.width, height: result.height)
        self.createdAt = result.createdAt
        self.welcomeDescription = result.description
        self.thumbImageURL = result.urls.thumb
        self.largeImageURL = result.urls.full
        self.isLiked = result.likedByUser
    }
}

struct LikedPhoto {
    let likedPhoto: PhotoResult
    
    init(likedPhotoResult: LikePhotoResult) {
        self.likedPhoto = likedPhotoResult.photo
    }
}
