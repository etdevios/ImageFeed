//
//  ImageFeedTests.swift
//  ImageFeedTests
//
//  Created by Eduard Tokarev on 16.03.2023.
//

@testable import ImageFeed
import XCTest

final class ImagesListServiceTests: XCTestCase {
    func testFetchPhotos() {
        let service = ImageListService.shared
        
        let expectation = self.expectation(description: "Wait for Notification")
        NotificationCenter.default.addObserver(forName: ImageListService.didChangeNotification, object: nil, queue: .main) { _ in
            expectation.fulfill()
        }
        
        service.fetchPhotosNextPage()
        wait(for: [expectation], timeout: 10)
        
        XCTAssertEqual(service.photos.count, 10)
        
        service.fetchPhotosNextPage()
        
        XCTAssertEqual(service.photos.count, 20)
    }
}
