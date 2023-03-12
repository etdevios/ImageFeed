//
//  Constants.swift
//  ImageFeed
//
//  Created by Eduard Tokarev on 16.02.2023.
//

import Foundation

struct K {
    struct API {
        static let accessKey = "6f4ioL9Gdmo3WscBtHVB4Nf6HOP2JunRBPG1YyjUAp4"
        static let secretKey = "rNsUmFeEvit_-DIdaZ7p15aXxlLCtcqIsaxpwhM8fDw"
        static let redirectURI = "urn:ietf:wg:oauth:2.0:oob"
        static let accessScope = "public+read_user+write_likes"
        static let defaultBaseURL = "https://api.unsplash.com"
        
        static let unsplashAuthorizeURLString = "https://unsplash.com/oauth/authorize"
    }
    
    struct IB {
        static let webViewSegueIdentifier = "ShowWebView"
//        static let authViewSegueIdentifier = "ShowAuthenticationScreen"
        static let tabBarControllerIdentifier = "TabBarViewController"
        static let authViewControllerIdentifier = "AuthViewController"
    }
}
