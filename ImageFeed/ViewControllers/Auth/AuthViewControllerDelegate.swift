//
//  AuthViewControllerDelegate.swift
//  ImageFeed
//
//  Created by Eduard Tokarev on 18.02.2023.
//

import Foundation

protocol AuthViewControllerDelegate: AnyObject {
    func authViewController(_ vc: AuthViewController, didAuthenticateWithCode code: String)
} 
