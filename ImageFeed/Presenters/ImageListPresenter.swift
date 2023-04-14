//
//  ImageListPresenter.swift
//  ImageFeed
//
//  Created by Eduard Tokarev on 14.04.2023.
//

import Foundation

public protocol ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol? { get set }
    
    func viewDidLoad()
}

final class ImagesListPresenter: ImagesListPresenterProtocol {
    weak var view: ImagesListViewControllerProtocol?
    private var imagesListServiceObserver: NSObjectProtocol?
    let imagesListService = ImagesListService.shared
    
    func viewDidLoad() {
        imagesListServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ImagesListService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                UIBlockingProgressHUD.dismiss()
                self.view?.updateTableViewAnimated()
            }
    }
}
