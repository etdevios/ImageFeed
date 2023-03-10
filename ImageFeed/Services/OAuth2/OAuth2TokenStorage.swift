//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Eduard Tokarev on 17.02.2023.
//

import Foundation
import SwiftKeychainWrapper

final class OAuth2TokenStorage {
    private let storage = KeychainWrapper.standard
    private let keyStorage = "bearer"
    
    var token: String? {
        get {
            storage.string(forKey: keyStorage)
        }
        
        set {
            guard let data = newValue else { return }
            storage.set(data, forKey: keyStorage)
        }
    }
    
    func deleteToken() {
        storage.removeObject(forKey: keyStorage)
    }
}
