//
//  AuthViewController.swift
//  ImageFeed
//
//  Created by Eduard Tokarev on 16.02.2023.
//

import UIKit

final class AuthViewController: UIViewController {
    private lazy var logoImageView = UIImageView()
    private lazy var loginButton = UIButton()
    
    weak var delegate: AuthViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createViews()
        addSubviews()
        addViewConstraints()
    }
    
    private func createViews() {
        logoImageView = {
            let imageView = UIImageView()
            imageView.image = UIImage(named: "auth_screen_logo")
            return imageView
        }()
        
        loginButton = {
            let button = UIButton(type: .system)
            button.addTarget(self, action: #selector(loginButtonTouched), for: .touchUpInside)
            
            button.setTitle("Войти", for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
            button.setTitleColor(.ypBlack, for: .normal)
            button.backgroundColor = .ypWhite
            return button
        }()
    }
    
    @objc func loginButtonTouched() {
        
    }
    
    private func addSubviews() {
        [logoImageView, loginButton].forEach { item in
            item.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(item)
        }
    }
    
    private func addViewConstraints() {
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 60),
            logoImageView.widthAnchor.constraint(equalToConstant: 60),
            
            loginButton.heightAnchor.constraint(equalToConstant: 48),
            loginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -90),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.IB.webViewSegueIdentifier {
            guard
                let webViewViewController = segue.destination as? WebViewViewController
            else { fatalError("Failed to prepare for \(K.IB.webViewSegueIdentifier)") }
            webViewViewController.delegate = self
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        delegate?.authViewController(self, didAuthenticateWithCode: code)
    }
    
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }
}

