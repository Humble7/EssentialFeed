//
//  FeedImagePresenterTest.swift
//  EssentialFeedTests
//
//  Created by ChenZhen on 25/1/25.
//

import XCTest
import EssentialFeed

class FeedImagePresenter {
    init(view: Any) {
        
    }
}

class FeedImagePresenterTest: XCTestCase {
    
    func test_init_doesNotSendMessagesToView() {
        let (_, view) = makeSUT()
        
        XCTAssertTrue(view.messages.isEmpty, "Expected no view messages")
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: FeedImagePresenter, view: ViewSpy) {
        let view = ViewSpy()
        let sut = FeedImagePresenter(view: view)
        trackForMemoryLeaks(view)
        trackForMemoryLeaks(sut)
        
        return (sut, view)
    }
    
    private class ViewSpy {
        let messages = [Any]()
    }
}
