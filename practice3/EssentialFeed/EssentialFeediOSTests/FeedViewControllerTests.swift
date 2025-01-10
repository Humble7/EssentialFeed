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
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)
        
        self.loader?.load() { _ in }
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
        sut.loadViewIfNeeded()
        sut.beginAppearanceTransition(true, animated: false)
        sut.endAppearanceTransition()
        
        XCTAssertEqual(loaderSpy.loadCallCount, 1)
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

        private(set) var loadCallCount: Int = 0

        func load(completion: @escaping (FeedLoader.Result) -> Void) {
            loadCallCount += 1
        }
    }
}
