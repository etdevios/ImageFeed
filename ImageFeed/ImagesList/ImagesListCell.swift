//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Eduard Tokarev on 19.01.2023.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    
    @IBOutlet weak var imageCell: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
}
