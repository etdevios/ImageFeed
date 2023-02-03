//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Eduard Tokarev on 02.02.2023.
//

import UIKit

final class ProfileViewController: UIViewController {
    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var nicknameLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var logoutView: UIButton!
    @IBAction func logoutButtonTapped(_ sender: UIButton) {
    }
}
