//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Eduard Tokarev on 02.02.2023.
//

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    private var avatarImageView = UIImageView()
    private let descriptionLabel = UILabel()
    private let nicknameLabel = UILabel()
    private let nameLabel = UILabel()
    private let logoutView = UIButton()
    
    private var oAuthTokenStorage =  OAuth2TokenStorage()
    private let profileService = ProfileService.shared
    
    private var profileImageServiceObserver: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        applyStyle()
        updateProfileDetails(with: profileService.profile)
        
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageServices.didChangeNotification,
                object: nil,
                queue: .main) { [weak self] _ in
                    guard let self = self else { return }
                    self.updateAvatar()
                }
        updateAvatar()
    }
    
    @objc
    private func logoutButtonTapped() {
    }
    
    private func applyStyle() {
        avatarImageView.image = UIImage(named: "avatar") ?? UIImage()
        avatarImageView.layer.cornerRadius = 61
        
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
    private func applyStyleLabel(
        _ label: UILabel,
        text: String = "",
        font: UIFont? = UIFont.systemFont(ofSize: 13),
        textColor: UIColor = .ypWhite
    ){
        label.text = text
        label.font = font
        label.textColor = textColor
    }
    
    private func updateProfileDetails(with profile: Profile?) {
        guard let profile = profile else { return }
        self.nameLabel.text = profile.name
        self.nicknameLabel.text = profile.loginName
        self.descriptionLabel.text = profile.bio
    }
    
    private func updateAvatar() {
        guard
            let profileImageURL = ProfileImageServices.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        
        avatarImageView.kf.setImage(with: url)
    }
}
