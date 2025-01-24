//
//  FeedPresenterTests.swift
//  EssentialFeedTests
//
//  Created by ChenZhen on 24/1/25.
//

import XCTest

struct FeedLoadingViewModel {
    let isLoading: Bool
}

protocol FeedLoadingView {
    func display(_ viewModel: FeedLoadingViewModel)
}

final class FeedPresenter {
    private let feedLoadingView: FeedLoadingView

    init(feedLoadingView: FeedLoadingView) {
        self.feedLoadingView = feedLoadingView
    }
    
    func didStartLoadingFeed() {
        feedLoadingView.display(FeedLoadingViewModel(isLoading: true))
    }
}

class FeedPresenterTests: XCTestCase {
    
    func test_init_doesNotSendMessagesToView() {
        let (_, view) = makeSUT()
        
        XCTAssertTrue(view.messages.isEmpty, "Expected no view messages")
    }
    
    func test_start() {
        let (sut, view) = makeSUT()
        sut.didStartLoadingFeed()
        
        XCTAssertEqual(view.messages, [.dispaly(true)])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: FeedPresenter, view: ViewSpy) {
        let view = ViewSpy()
        let sut = FeedPresenter(feedLoadingView: view)
        trackForMemoryLeaks(view)
        trackForMemoryLeaks(sut)
        
        return (sut, view)
    }
    
    private class ViewSpy: FeedLoadingView {
        func display(_ viewModel: FeedLoadingViewModel) {
            messages.append(.dispaly(viewModel.isLoading))
        }
        
        
        enum Message: Equatable {
            case dispaly(_ isLoading: Bool)
        }
        
        var messages = [Message]()
    }
}
