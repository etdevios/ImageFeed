//
//  WebViewViewControllerDelegate.swift
//  ImageFeed
//
//  Created by Eduard Tokarev on 17.02.2023.
//

import Foundation

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}
