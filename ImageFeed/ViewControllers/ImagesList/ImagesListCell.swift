//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Eduard Tokarev on 19.01.2023.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    private let gradientLayer = CAGradientLayer()
    
    private lazy var imageCell: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypWhite
        return label
    }()
    
    private lazy var gradientView: UIView = {
        let view = UIView()
        return view
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubviews()
        addViewConstraints()
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: self.layer)
        gradientLayer.frame = gradientView.bounds
    }
    
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
}

private extension ImagesListCell {
    func addSubviews() {
        [imageCell, gradientView, likeButton, dateLabel].forEach { item in
            item.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(item)
        }
    }
    
    func addViewConstraints() {
        NSLayoutConstraint.activate([
            imageCell.trailingAnchor.constraint(greaterThanOrEqualTo: contentView.trailingAnchor, constant: -16),
            imageCell.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            imageCell.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            imageCell.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            
            gradientView.heightAnchor.constraint(equalToConstant: 30),
            gradientView.bottomAnchor.constraint(equalTo: imageCell.bottomAnchor),
            gradientView.trailingAnchor.constraint(equalTo: imageCell.trailingAnchor),
            gradientView.leadingAnchor.constraint(equalTo: imageCell.leadingAnchor),
            
            likeButton.widthAnchor.constraint(equalToConstant: 42),
            likeButton.heightAnchor.constraint(equalToConstant: 42),
            likeButton.trailingAnchor.constraint(equalTo: imageCell.trailingAnchor),
            likeButton.topAnchor.constraint(equalTo: imageCell.topAnchor),
            
            dateLabel.trailingAnchor.constraint(greaterThanOrEqualTo: imageCell.trailingAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: imageCell.bottomAnchor, constant: -8),
            dateLabel.leadingAnchor.constraint(equalTo: imageCell.leadingAnchor, constant: 8)
        ])
    }
}
