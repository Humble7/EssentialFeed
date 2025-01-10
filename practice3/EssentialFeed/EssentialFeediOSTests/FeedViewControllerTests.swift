//
//  FeedViewControllerTests.swift
//  EssentialFeediOSTests
//
//  Created by ChenZhen on 9/1/25.
//

import XCTest
import UIKit
import EssentialFeed
import EssentialFeediOS

final class FeedViewControllerTests: XCTestCase {
    
    func test_loadFeedActions_requestFeedFromLoader() {
        let (sut, loaderSpy) = makeSUT()
        XCTAssertEqual(loaderSpy.loadCallCount, 0, "Expected no loading requests before view is loaded")

        sut.loadViewIfNeeded()
        XCTAssertEqual(loaderSpy.loadCallCount, 0, "Expected no loading requests once view is loaded")

        sut.simulateAppearance()
        XCTAssertEqual(loaderSpy.loadCallCount, 1, "Expected a loading request once view is appearing")
        
        sut.simulateUserInitiatedFeedReload()
        XCTAssertEqual(loaderSpy.loadCallCount, 2, "Expected another loading request once user initiates reload")
        
        sut.simulateUserInitiatedFeedReload()
        XCTAssertEqual(loaderSpy.loadCallCount, 3, "Expected a third loading request once user initiates another reload")
    }
    
    func test_loadingFeedIndicator_isVisibleWhileLoadingFeed() {
        let (sut, loader) = makeSUT()
        sut.simulateAppearance()
        XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator once view is appearing")

        loader.completeFeedLoading(at: 0)
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once loading is completed")
        
        sut.simulateUserInitiatedFeedReload()
        XCTAssertTrue(sut.isShowingLoadingIndicator, "Expected loading indicator once user initiated reload")

        loader.completeFeedLoading(at: 1)
        XCTAssertFalse(sut.isShowingLoadingIndicator, "Expected no loading indicator once user initiated loading is completed")
    }
    
    // MARKS: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: FeedViewController, loader: LoaderSpy) {
        let loaderSpy = LoaderSpy()
        let sut = FeedViewController(loader: loaderSpy)
        trackForMemoryLeaks(loaderSpy, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, loaderSpy)
    }
    
    class LoaderSpy: FeedLoader {

        var completions = [(FeedLoader.Result) -> Void]()
        var loadCallCount: Int {
            completions.count
        }

        func load(completion: @escaping (FeedLoader.Result) -> Void) {
            completions.append(completion)
        }
        
        func completeFeedLoading(at index: Int = 0) {
            completions[index](.success([]))
        }
    }
}

private extension FeedViewController {
    
    var isShowingLoadingIndicator: Bool {
        refreshControl?.isRefreshing ?? false
    }
    
    func simulateUserInitiatedFeedReload() {
        refreshControl?.simulatePullToRefresh()
    }
    
    func simulateAppearance() {
        if !isViewLoaded {
            loadViewIfNeeded()
            
            let fakeRefreshControl = FakeRefreshControl()
            refreshControl?.allTargets.forEach { target in
                refreshControl?.actions(forTarget: target, forControlEvent: .valueChanged)?.forEach { action in
                    fakeRefreshControl.addTarget(target, action: Selector(action), for: .valueChanged)
                }
            }
            
            refreshControl = fakeRefreshControl
        }
        
        beginAppearanceTransition(true, animated: false)
        endAppearanceTransition()
    }
}

private class FakeRefreshControl: UIRefreshControl {
    private var _isRefreshing: Bool = false
    
    override var isRefreshing: Bool {
        _isRefreshing
    }
    
    override func beginRefreshing() {
        _isRefreshing = true
    }
    
    override func endRefreshing() {
        _isRefreshing = false
    }
}

private extension UIRefreshControl {
    func simulatePullToRefresh() {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: .valueChanged)?.forEach({ action in
                (target as NSObject).perform(Selector(action))
            })
        }
    }
}
