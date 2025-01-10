//
//  FeedViewControllerTests.swift
//  EssentialFeediOSTests
//
//  Created by ChenZhen on 9/1/25.
//

import XCTest
import UIKit
import EssentialFeed

final class FeedViewController: UITableViewController {
    private var loader: FeedLoader?
    convenience init(loader: FeedLoader) {
        self.init()
        self.loader = loader
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(load), for: .valueChanged)
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        load()
    }
    
    @objc private func load() {
        refreshControl?.beginRefreshing()
        loader?.load { [weak self] _ in
            self?.refreshControl?.endRefreshing()
        }
    }
    
}

final class FeedViewControllerTests: XCTestCase {
    
    func test_init_doesNotLoadFeed() {
        let (_, loaderSpy) = makeSUT()
        
        XCTAssertEqual(loaderSpy.loadCallCount, 0)
    }
    
    func test_viewDidLoad_doesNotLoadsFeed() {
        let (sut, loaderSpy) = makeSUT()

        sut.loadViewIfNeeded()
        
        XCTAssertEqual(loaderSpy.loadCallCount, 0)
    }
    
    func test_viewIsAppearing_loadsFeed() {
        let (sut, loaderSpy) = makeSUT()
        sut.simulateAppearance()
        
        XCTAssertEqual(loaderSpy.loadCallCount, 1)
    }
    
    func test_pullToRefresh_loadsFeed() {
        let (sut, loaderSpy) = makeSUT()
        sut.simulateAppearance()
        
        sut.refreshControl?.simulatePullToRefresh()
        
        XCTAssertEqual(loaderSpy.loadCallCount, 2)
    }
    
    func test_viewIsAppearing_showsLoadingIndicator() {
        let (sut, _) = makeSUT()
        sut.simulateAppearance()
        
        XCTAssertTrue(sut.refreshControl!.isRefreshing)
    }
    
    func test_viewIsAppearing_hidesLoadingIndicatorOnLoaderCompletion() {
        let (sut, loader) = makeSUT()
        
        sut.simulateAppearance()
        loader.completeFeedLoading()
        
        XCTAssertEqual(sut.refreshControl!.isRefreshing, false)
    }
    
    func test_pullToRefresh_showsLoadingIndicator() {
        let (sut, loader) = makeSUT()
        sut.simulateAppearance()
        loader.completeFeedLoading()
        
        sut.refreshControl?.simulatePullToRefresh()
        
        XCTAssertTrue(sut.refreshControl!.isRefreshing)
    }
    
    func test_pullToRefresh_hidesLoadingIndicatorOnLoaderCompletion() {
        let (sut, loader) = makeSUT()
        sut.simulateAppearance()
        loader.completeFeedLoading()
        
        sut.refreshControl?.simulatePullToRefresh()
        loader.completeFeedLoading()

        XCTAssertEqual(sut.refreshControl!.isRefreshing, false)
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
        private(set) var loadCallCount: Int = 0

        func load(completion: @escaping (FeedLoader.Result) -> Void) {
            loadCallCount += 1
            completions.append(completion)
        }
        
        func completeFeedLoading() {
            completions[0](.success([]))
        }
    }
}

private extension FeedViewController {
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
