//
//  ProfileResult.swift
//  ImageFeed
//
//  Created by Eduard Tokarev on 05.03.2023.
//

import Foundation

struct ProfileResult: Codable {
    let username: String
    let firstName: String
    let lastName: String
    let bio: String?
}
