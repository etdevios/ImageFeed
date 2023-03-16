//
//  PhotoResult.swift
//  ImageFeed
//
//  Created by Eduard Tokarev on 16.03.2023.
//

import Foundation

struct UrlsResult: Decodable {
    let full: String
    let thumb: String
}

struct PhotoResult: Decodable {
    let id: String
    let createdAt: Date?
    let width: Int
    let height: Int
    let description: String?
    let likedByUser: Bool
    let urls: UrlsResult
}


