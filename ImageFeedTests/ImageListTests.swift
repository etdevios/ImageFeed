//
//  ImageListTests.swift
//  ImageFeedTests
//
//  Created by Eduard Tokarev on 14.04.2023.
//

@testable import ImageFeed
import XCTest

final class ImagesListViewPresenterSpy: ImagesListPresenterProtocol {
    var view: ImagesListViewControllerProtocol?
    var viewDidLoadCalled: Bool = false
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
}

final class ImagesListTests: XCTestCase {
    func testViewControllerCallsViewDidLoad() {
        //given
        
        let viewController = ImagesListViewController()
        let presenter = ImagesListViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        _ = viewController.view
        
        //then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
}


