//
//  SplashViewController.swift
//  ImageFeed
//
//  Created by Eduard Tokarev on 18.02.2023.
//

import UIKit
import ProgressHUD

final class SplashViewController: UIViewController {
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "splash_screen_logo")
        return imageView
    }()
    
    private let oauth2Service = OAuth2Service()
    private var oauth2TokenStorage = OAuth2TokenStorage()
    
    private let profileService = ProfileService.shared
    private let profileImageService = ProfileImageServices.shared
    
    override func viewDidLoad() {
        view.backgroundColor = .ypBlack
        layoutLogo()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if oauth2TokenStorage.token != nil {
            guard let token = oauth2TokenStorage.token else { return }
            fetchProfile(token)
        } else {
            presentAuthViewController()
        }
    }
}

extension SplashViewController {
    private func switchToTabBarController() {
        let tabBarController = TabBarController()
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration ") }
        
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }
    
    private func presentAuthViewController() {
        let authViewController = AuthViewController()
        authViewController.delegate = self
        
        let navigationAuthViewController = UINavigationController(rootViewController: authViewController)
        navigationAuthViewController.modalPresentationStyle = .fullScreen
        present(navigationAuthViewController, animated: true)
    }
    
    private func getViewController(withIdentifier id: String) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let viewController = storyboard.instantiateViewController(withIdentifier: id)
        return viewController
    }
    
    private func fetchProfile(_ token: String?) {
        guard let token  else { return }
        profileService.fetchProfile(token) {  result in
            switch result {
            case .success(let userProfile):
                UIBlockingProgressHUD.dismiss()
                self.profileImageService.fetchProfileImageURL(username: userProfile.username) { _ in }
                self.switchToTabBarController()
            case .failure(let error):
                self.showAlert(with: error)
                UIBlockingProgressHUD.dismiss()
            }
        }
    }
    
    private func showAlert(with error: Error) {
        let alert = UIAlertController(
            title: "Что-то пошло не так(",
            message: "Не удалось войти в систему. Ошибка: \(error)",
            preferredStyle: .alert
        )
        let action = UIAlertAction(title: "OK", style: .cancel)
        alert.addAction(action)
        self.present(alert, animated: true)
    }
    
    private func layoutLogo() {
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(logoImageView)
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

//MARK: - AuthViewControllerDelegate
extension SplashViewController: AuthViewControllerDelegate {
    func authViewController(
        _ vc: AuthViewController,
        didAuthenticateWithCode code: String
    ) {
        UIBlockingProgressHUD.show()
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            self.fetchOAuthToken(code)
        }
    }
    
    private func fetchOAuthToken(_ code: String) {
        oauth2Service.fetchAuthToken(code) { result in
            switch result {
            case .success(let response):
                self.oauth2TokenStorage.token = response.accessToken
                self.fetchProfile(self.oauth2TokenStorage.token)
                self.switchToTabBarController()
                UIBlockingProgressHUD.dismiss()
            case .failure(let error):
                self.showAlert(with: error)
                UIBlockingProgressHUD.dismiss()
            }
        }
    }
}
