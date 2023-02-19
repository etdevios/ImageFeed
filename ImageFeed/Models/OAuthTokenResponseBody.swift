//
//  OAuthTokenResponseBody.swift
//  ImageFeed
//
//  Created by Eduard Tokarev on 17.02.2023.
//

import Foundation

struct OAuthTokenResponseBody: Decodable {
    let accessToken: String
    let tokenType: String
    let scope: String
    let createdAt: Int
}
