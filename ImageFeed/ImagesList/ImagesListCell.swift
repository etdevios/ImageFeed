//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Eduard Tokarev on 19.01.2023.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    static let reuseIdentifier = "ImagesListCell"
    private let gradientLayer = CAGradientLayer()
    
    @IBOutlet private weak var imageCell: UIImageView!
    @IBOutlet private weak var likeButton: UIButton!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var gradientView: UIView!
    
    func setup(withImage image: UIImage, date formattedDate: String, isLiked: Bool) {
        imageCell.image = image
        
        gradientLayer.colors = [
            UIColor.ypBlack.withAlphaComponent(0).cgColor,
            UIColor.ypBlack.withAlphaComponent(0.2).cgColor
        ]
        gradientView.layer.insertSublayer(gradientLayer, at: 0)
        
        dateLabel.text = formattedDate
        
        let nameImageLike = isLiked ? "like_button_on" : "like_button_off"
        let likeImage = UIImage(named: nameImageLike)
        likeButton.setImage(likeImage, for: .normal)
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: self.layer)
        gradientLayer.frame = gradientView.bounds
    }
}
