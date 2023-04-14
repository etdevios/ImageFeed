//
//  ProfileViewTests.swift
//  ImageFeedTests
//
//  Created by Eduard Tokarev on 14.04.2023.
//

@testable import ImageFeed
import XCTest

final class ProfileViewPresenterSpy: ProfilePresenterProtocol {
    var view: ProfileViewControllerProtocol?
    var viewDidLoadCalled: Bool = false
    var logOutButtonWasTapped: Bool = false
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
}

final class ProfileViewTests: XCTestCase {
    func testViewControllerCallsViewDidLoad() {
        //given
        
        let viewController = ProfileViewController()
        let presenter = ProfileViewPresenterSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        
        //when
        _ = viewController.view
        
        //then
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
}

