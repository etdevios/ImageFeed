//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Eduard Tokarev on 18.02.2023.
//

import UIKit

final class SplashViewController: UIViewController {
    private let oauth2Service = OAuth2Service()
    private let oauth2TokenStorage = OAuth2TokenStorage()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if OAuth2TokenStorage().token != nil {
            switchToTabBarController()
        } else {
            performSegue(withIdentifier: K.IB.authViewSegueIdentifier, sender: nil)
        }
    }
}

extension SplashViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.IB.authViewSegueIdentifier {
            guard
                let navigationController = segue.destination as? UINavigationController,
                let viewController = navigationController.viewControllers[0] as? AuthViewController
            else { fatalError("Failed to prepare for \(K.IB.authViewSegueIdentifier)") }
            viewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    private func switchToTabBarController() {
        guard let window = UIApplication.shared.windows.first
        else { fatalError("Invalid Configuration ") }
        let tabBarController = UIStoryboard(
            name: "Main",
            bundle: .main
        )
            .instantiateViewController(
                withIdentifier: K.IB.storyboardIDTabBar
            )
        window.rootViewController = tabBarController
    }
}

extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(
        _ vc: AuthViewController,
        didAuthenticateWithCode code: String
    ) {
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.oauth2Service.fetchAuthToken(code: code) { result in
                switch result {
                case.success(let response):
                    self.oauth2TokenStorage.token = response.accessToken
                    self.switchToTabBarController()
                case.failure:
                    
                    break
                }
            }
        }
    }
}
