//
//  AuthConfiguration.swift
//  ImageFeed
//
//  Created by Eduard Tokarev on 13.04.2023.
//

import Foundation

let AccessKey = "6f4ioL9Gdmo3WscBtHVB4Nf6HOP2JunRBPG1YyjUAp4"
let SecretKey = "rNsUmFeEvit_-DIdaZ7p15aXxlLCtcqIsaxpwhM8fDw"
let RedirectURI = "urn:ietf:wg:oauth:2.0:oob"
let AccessScope = "public+read_user+write_likes"

let DefaultBaseURL = URL(string: "https://api.unsplash.com")!
let UnsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"

struct AuthConfiguration {
    let accessKey: String
    let secretKey: String
    let redirectURI: String
    let accessScope: String
    let defaultBaseURL: URL
    let authURLString: String
    
    init(accessKey: String, secretKey: String, redirectURI: String, accessScope: String, authURLString: String, defaultBaseURL: URL) {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.redirectURI = redirectURI
        self.accessScope = accessScope
        self.defaultBaseURL = defaultBaseURL
        self.authURLString = authURLString
    }
    
    static var standard: AuthConfiguration {
        return AuthConfiguration(accessKey: AccessKey, secretKey: SecretKey, redirectURI: RedirectURI, accessScope: AccessScope, authURLString: UnsplashAuthorizeURLString, defaultBaseURL: DefaultBaseURL)
    }
}
