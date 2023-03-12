//
//  Profile.swift
//  ImageFeed
//
//  Created by Eduard Tokarev on 05.03.2023.
//

import Foundation

struct Profile: Decodable {
    let username: String
    let name: String
    let loginName: String
    let bio: String?
    
    init(from result: ProfileResult) {
        self.username = result.username
        self.name = "\(result.firstName) \(result.lastName)"
        self.loginName = "@\(username)"
        self.bio = result.bio
    }
}
