//
//  UserResult.swift
//  ImageFeed
//
//  Created by Eduard Tokarev on 05.03.2023.
//

import Foundation

struct UserResult: Decodable {
    let profileImage: ProfileImage
    
    struct ProfileImage: Decodable {
        let small: String
    }
}
