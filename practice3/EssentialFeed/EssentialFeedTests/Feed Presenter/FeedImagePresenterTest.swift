//
//  FeedImagePresenterTest.swift
//  EssentialFeedTests
//
//  Created by ChenZhen on 25/1/25.
//

import XCTest
import EssentialFeed

struct FeedImageViewModel {
    var description: String?
    var location: String?
    var image: Any?
    var isLoading: Bool
    var shouldRetry: Bool
    
    var hasLocation: Bool {
        return location != nil
    }
}

protocol FeedImageView {
    func display(_ viewModel: FeedImageViewModel)
}

class FeedImagePresenter {
    private let view: FeedImageView

    init(view: FeedImageView) {
        self.view = view
    }
    
    func didStartLoadingImageData(for model: FeedImage) {
        view.display(FeedImageViewModel(description: model.description, location: model.location, isLoading: true, shouldRetry: false))
    }
}

class FeedImagePresenterTest: XCTestCase {
    
    func test_init_doesNotSendMessagesToView() {
        let (_, view) = makeSUT()
        
        XCTAssertTrue(view.messages.isEmpty, "Expected no view messages")
    }
    
    func test_didStartLoadingImageData_displaysLoadingImage() {
        let (sut, view) = makeSUT()
        let image = uniqueImage()
        
        sut.didStartLoadingImageData(for: image)
        
        let message = view.messages.first
        XCTAssertEqual(view.messages.count, 1)
        XCTAssertEqual(message?.description, image.description)
        XCTAssertEqual(message?.location, image.location)
        XCTAssertEqual(message?.isLoading, true)
        XCTAssertEqual(message?.shouldRetry, false)
        XCTAssertNil(message?.image)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: FeedImagePresenter, view: ViewSpy) {
        let view = ViewSpy()
        let sut = FeedImagePresenter(view: view)
        trackForMemoryLeaks(view)
        trackForMemoryLeaks(sut)
        
        return (sut, view)
    }
    
    private class ViewSpy: FeedImageView {
        var messages = [FeedImageViewModel]()
        
        func display(_ viewModel: FeedImageViewModel) {
            messages.append(viewModel)
        }
    }
}
