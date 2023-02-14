//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Eduard Tokarev on 02.02.2023.
//

import UIKit

final class ProfileViewController: UIViewController {
    private var avatarImageView = UIImageView()
    private let descriptionLabel = UILabel()
    private let nicknameLabel = UILabel()
    private let nameLabel = UILabel()
    private let logoutView = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        applyStyle()
    }
    
    @objc
    private func logoutButtonTapped() {
        print("Good luck")
    }
    
    func applyStyle() {
        avatarImageView.image = UIImage(named: "avatar") ?? UIImage()
        avatarImageView.layer.cornerRadius = 35
        
        applyStyleLabel(
            nameLabel,
            text: "Екатерина Новикова",
            font: UIFont.systemFont(ofSize: 23, weight: .bold)
        )
        
        applyStyleLabel(
            nicknameLabel,
            text: "@ekaterina_nov",
            textColor: .gray
        )
        
        applyStyleLabel(
            descriptionLabel,
            text: "Hello, world!"
        )
        
        logoutView.setImage(UIImage(named: "logout_button"), for: .normal)
        logoutView.addTarget(self, action: #selector(logoutButtonTapped), for: .touchUpInside)
        logoutView.tintColor = .ypRed
        
    }
    
    private func setupLayout() {
        [avatarImageView, nameLabel, nicknameLabel, descriptionLabel, logoutView].forEach { item in
            item.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(item)
        }
        
        NSLayoutConstraint.activate([
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),
            avatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor),
            nicknameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            nicknameLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: nicknameLabel.bottomAnchor, constant: 8),
            descriptionLabel.leadingAnchor.constraint(equalTo: nicknameLabel.leadingAnchor),
            logoutView.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            logoutView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    // MARK: Supporting methods
    func applyStyleLabel(
        _ label: UILabel,
        text: String = "",
        font: UIFont? = UIFont.systemFont(ofSize: 13),
        textColor: UIColor = .ypWhite
    ){
        label.text = text
        label.font = font
        label.textColor = textColor
    }
}
