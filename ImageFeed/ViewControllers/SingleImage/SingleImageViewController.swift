//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Eduard Tokarev on 03.02.2023.
//

import UIKit
import Kingfisher

final class SingleImageViewController: UIViewController {
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
        return scrollView
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.setImage(UIImage(named: "nav_back_button_white"), for: .normal)
        button.accessibilityIdentifier = "navBackButton"
        return button
    }()
    
    private lazy var shareButton: UIButton = {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(didTapShareButton), for: .touchUpInside)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.setImage(UIImage(named: "share_button"), for: .normal)
        return button
    }()
    
    var fullImageUrl: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        setImage()
        addSubviews()
        addViewConstraints()
        createViews()
    }
    
    @objc private func didTapBackButton() {
        dismiss(animated: true)
    }
    
    @objc private func didTapShareButton() {
        guard let image = imageView.image else { return }
        let share = UIActivityViewController(
            activityItems: [image],
            applicationActivities: nil
        )
        present(share, animated: true)
    }
    
    private func setImage() {
        UIBlockingProgressHUD.show()
        guard let urlString = fullImageUrl else { return }
        let url = URL(string: urlString)
        DispatchQueue.main.async {
            self.imageView.kf.setImage(with: url) { [weak self] result in
                UIBlockingProgressHUD.dismiss()
                guard let self = self else { return }
                switch result {
                case .success(let imageResult):
                    self.rescaleAndCenterImageInScrollView(image: imageResult.image)
                case .failure(let error):
                    self.showError(with: error)
                }
            }
        }
    }
    
    private func showError(with error: Error) {
        let alert = UIAlertController(
            title: "Что-то пошло не так.",
            message: "Ошибка - \(error). Попробовать еще раз?",
            preferredStyle: .alert
        )
        let cancelAction = UIAlertAction(title: "Не надо", style: .cancel)
        let repeatAction = UIAlertAction(title: "Повторить", style: .default) { [weak self] _ in
            self?.setImage()
        }
        [cancelAction, repeatAction].forEach { item in
            alert.addAction(item)
        }
        alert.overrideUserInterfaceStyle = UIUserInterfaceStyle.light
        self.present(alert, animated: true)
    }
    
    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        view.layoutIfNeeded()
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
}

private extension SingleImageViewController {
    func createViews() {
        view.backgroundColor = .ypBlack
    }
    
    func addSubviews() {
        [scrollView, backButton, shareButton].forEach { item in
            item.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(item)
        }
        
        [imageView].forEach { item in
            item.translatesAutoresizingMaskIntoConstraints = false
            scrollView.addSubview(item)
        }
    }
    
    func addViewConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            imageView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            backButton.heightAnchor.constraint(equalToConstant: 24),
            backButton.widthAnchor.constraint(equalToConstant: 24),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 9),
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 9),
            
            shareButton.heightAnchor.constraint(equalToConstant: 50),
            shareButton.widthAnchor.constraint(equalToConstant: 50),
            shareButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -17),
            shareButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        let halfWidth = (scrollView.bounds.size.width - imageView.frame.width) / 2
        let halfHeight = (scrollView.bounds.size.height - imageView.frame.height) / 2
        scrollView.contentInset = .init(top: halfHeight, left: halfWidth, bottom: 0, right: 0)
    }
}
