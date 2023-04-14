//
//  TabBarController.swift
//  ImageFeed
//
//  Created by Eduard Tokarev on 09.03.2023.
//

import UIKit

final class TabBarController: UITabBarController {
    private enum TabBarItem: Int {
        case imageList
        case profile
        
        var iconName: String {
            switch self {
            case .imageList:
                return "tab_editorial_active"
            case .profile:
                return "tab_profile_active"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBar()
    }
    
    private func setupTabBar() {
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = .ypBlack
        tabBar.standardAppearance = appearance
        tabBar.tintColor = .ypWhite
        
        let imagesListViewController = ImagesListViewController()
        let imagesListPresenter = ImagesListPresenter()
        imagesListViewController.presenter = imagesListPresenter
        imagesListPresenter.view = imagesListViewController
        
        let profileViewController = ProfileViewController()
        let profilePresenter = ProfilePresenter()
        profileViewController.presenter = profilePresenter
        profilePresenter.view = profileViewController
        
        let dataSource: [TabBarItem] = [.imageList, .profile]
        self.viewControllers = dataSource.map {
            switch $0 {
            case .imageList:
                return imagesListViewController
            case .profile:
                return profileViewController
            }
        }
        
        self.viewControllers?.enumerated().forEach {
            $1.tabBarItem.image = UIImage(named: dataSource[$0].iconName)
            $1.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: .zero, bottom: -5, right: .zero)
        }
    }
}

