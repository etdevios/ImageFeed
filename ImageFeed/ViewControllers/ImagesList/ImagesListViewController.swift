//
//  ViewController.swift
//  ImageFeed
//
//  Created by Eduard Tokarev on 19.01.2023.
//

import UIKit
import Kingfisher
import ProgressHUD

final class ImagesListViewController: UIViewController {
    private var photos: [Photo] = []
    private let imagesListService = ImagesListService.shared
    private var imagesListServiceObserver: NSObjectProtocol?
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ImagesListCell.self, forCellReuseIdentifier: String(describing: ImagesListCell.self))
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = .ypBlack
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        return tableView
    }()
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        addSubviews()
        addViewConstraints()
        createViews()
        UIBlockingProgressHUD.show()
        imagesListService.fetchPhotosNextPage()
        addNotificationObserver()
    }
    
    func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos
        
        if oldCount != newCount {
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            }
        }
    }
    
    func addNotificationObserver() {
        imagesListServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ImagesListService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                UIBlockingProgressHUD.dismiss()
                self?.updateTableViewAnimated()
            }
    }
}

private extension ImagesListViewController {
    func createViews() {
        view.backgroundColor = .ypBlack
    }
    
    func addSubviews() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
    }
    
    func addViewConstraints() {
        NSLayoutConstraint.activate([
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor)
        ])
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (indexPath.row + 1) == photos.count {
            UIBlockingProgressHUD.show()
            imagesListService.fetchPhotosNextPage()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: String(describing: ImagesListCell.self),
            for: indexPath
        )
        
        guard let imageListCell = cell as? ImagesListCell else { return UITableViewCell() }
        imageListCell.delegate = self
        configCell(for: imageListCell, with: indexPath)
        
        return imageListCell
    }
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        let photo = photos[indexPath.row]
        var formattedDate: String = ""
        if let dateString = photo.createdAt {
            formattedDate = dateFormatter.string(from: dateString)
        }
        
        
        cell.backgroundColor = .ypBlack
        cell.selectionStyle = .none
        
        cell.cellState = .loading
        guard let imageURL = URL(string: photo.thumbImageURL) else { return }
        KingfisherManager.shared.retrieveImage(with: imageURL) { [weak self] result in
            switch result {
            case .success(let imageResult):
                cell.imageCell.kf.indicatorType = .none
                self?.tableView.reloadRows(at: [indexPath], with: .automatic)
                cell.cellState = .finished(imageResult.image, formattedDate, photo.isLiked)
            case .failure(let error):
                print(error)
                cell.cellState = .error
            }
        }
    }
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let singleImageViewController = SingleImageViewController()
        let imageURL = photos[indexPath.row].largeImageURL
        singleImageViewController.fullImageUrl = imageURL
        singleImageViewController.modalPresentationStyle = .fullScreen
        present(singleImageViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let photo = photos[indexPath.row]
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = photo.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = photo.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
}

extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = photos[indexPath.row]
        UIBlockingProgressHUD.show()
        imagesListService.changeLike(photoId: photo.id, isLike: !photo.isLiked) { [weak self] result in
            guard let self = self else { return }
            UIBlockingProgressHUD.dismiss()
            switch result {
            case .success:
                self.photos = self.imagesListService.photos
                self.tableView.reloadRows(at: [indexPath], with: .automatic)
            case .failure(let error):
                self.showAlert(with: error)
            }
        }
    }
    
    private func showAlert(with error: Error) {
        let alert = UIAlertController(title: "Лайки сломались", message: "Ошибка - \(error)", preferredStyle: .alert)
        let action = UIAlertAction(title: "Oк", style: .cancel)
        alert.overrideUserInterfaceStyle = UIUserInterfaceStyle.light
        alert.addAction(action)
        self.present(alert, animated: true)
    }
}
